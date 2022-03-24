{% macro split_part(string_text, delimiter_text, part_number, quote_string_text=False, quote_delimiter_text=False) %}
  {{ return(adapter.dispatch('split_part', 'dbt_utils') (string_text, delimiter_text, part_number, quote_string_text, quote_delimiter_text)) }}
{% endmacro %}


{% macro default__split_part(string_text, delimiter_text, part_number, quote_string_text=False, quote_delimiter_text=False) -%}

    split_part(
        {% if not quote_string_text -%}
                {{ string_text }},
            {%- else -%}
                '{{ string_text }}',
        {%- endif %}
        {% if not quote_delimiter_text -%}
                {{ delimiter_text }},
            {%- else -%}
                '{{ delimiter_text }}',
        {%- endif %}
        {{ part_number }}
        )

{%- endmacro %}


{% macro bigquery__split_part(string_text, delimiter_text, part_number, quote_string_text=False, quote_delimiter_text=False) -%}

    split(
        {% if not quote_string_text -%}
                {{ string_text }},
            {%- else -%}
                '{{ string_text }}',
        {%- endif %}
        {% if not quote_delimiter_text -%}
                {{ delimiter_text }}
            {%- else -%}
                '{{ delimiter_text }}'
        {%- endif %}
        )[safe_offset({{ part_number - 1 }})]

{%- endmacro %}
