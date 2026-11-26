{% macro get_columns_by_pattern(from, pattern, exclude='') -%}
    {{ return(adapter.dispatch('get_columns_by_pattern', 'dbt_utils')(from, pattern, exclude)) }}
{% endmacro %}

{% macro default__get_columns_by_pattern(from, pattern, exclude='') -%}
    {%- do dbt_utils._is_relation(from, 'get_columns_by_pattern') -%}
    {%- do dbt_utils._is_ephemeral(from, 'get_columns_by_pattern') -%}

    {# Prevent querying of db in parsing mode. This works because this macro does not create any new refs. #}
    {%- if not execute -%}
        {{ return([]) }}
    {% endif %}

    {%- set matched_cols = [] %}
    {%- set cols = adapter.get_columns_in_relation(from) -%}

    {# Convert SQL LIKE pattern to regex-compatible pattern #}
    {# % becomes .*, _ becomes ., escape special regex chars #}
    {%- set pattern_lower = pattern | lower -%}
    {%- set exclude_lower = exclude | lower -%}

    {%- for col in cols -%}
        {%- set col_name_lower = col.column | lower -%}

        {# Check if column matches the pattern #}
        {%- if dbt_utils._matches_pattern(col_name_lower, pattern_lower) -%}
            {# Check if column should be excluded #}
            {%- if exclude == '' or not dbt_utils._matches_pattern(col_name_lower, exclude_lower) -%}
                {% do matched_cols.append(col.column) %}
            {%- endif -%}
        {%- endif -%}
    {%- endfor %}

    {{ return(matched_cols) }}

{%- endmacro %}

{# Helper macro to match SQL LIKE patterns #}
{% macro _matches_pattern(text, pattern) -%}
    {# Convert SQL LIKE pattern (%, _) to simple string matching #}
    {# This is a simplified implementation that handles common cases #}

    {%- set pattern_parts = [] -%}
    {%- set current_part = '' -%}
    {%- set i = 0 -%}

    {# Parse the pattern into parts #}
    {%- if pattern.startswith('%') and pattern.endswith('%') -%}
        {# Pattern is %text% - match if contains #}
        {%- set search_text = pattern[1:-1] -%}
        {%- if search_text in text -%}
            {{ return(true) }}
        {%- else -%}
            {{ return(false) }}
        {%- endif -%}
    {%- elif pattern.startswith('%') -%}
        {# Pattern is %text - match if ends with #}
        {%- set search_text = pattern[1:] -%}
        {%- if text.endswith(search_text) -%}
            {{ return(true) }}
        {%- else -%}
            {{ return(false) }}
        {%- endif -%}
    {%- elif pattern.endswith('%') -%}
        {# Pattern is text% - match if starts with #}
        {%- set search_text = pattern[:-1] -%}
        {%- if text.startswith(search_text) -%}
            {{ return(true) }}
        {%- else -%}
            {{ return(false) }}
        {%- endif -%}
    {%- else -%}
        {# No wildcards - exact match #}
        {%- if text == pattern -%}
            {{ return(true) }}
        {%- else -%}
            {{ return(false) }}
        {%- endif -%}
    {%- endif -%}
{%- endmacro %}
