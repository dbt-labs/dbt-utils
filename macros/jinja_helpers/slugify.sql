{% macro slugify(string) %}
  {{ return(adapter.dispatch('slugify', 'dbt_utils')(string)) }}
{% endmacro %}

{% macro default__slugify(string) %}

{#- Lower case the string -#}
{% set string = string | lower %}
{#- Replace spaces and dashes with underscores -#}
{% set string = modules.re.sub('[ -]+', '_', string) %}
{#- Only take letters, numbers, and underscores -#}
{% set string = modules.re.sub('[^a-z0-9_]+', '', string) %}

{{ return(string) }}

{% endmacro %}

{#- For Snowflake naming requirements -#}
{% macro snowflake__slugify(string) %}

{#- Lower case the string -#}
{% set string = string | lower %}
{#- Replace spaces and dashes with underscores -#}
{% set string = modules.re.sub('[ -]+', '_', string) %}
{#- Only take letters, numbers, and underscores -#}
{% set string = modules.re.sub('[^a-z0-9_]+', '', string) %}
{#- For Snowflake rules, will prepend "_" if col begins with a number -#}
{% set string = modules.re.sub('^[0-9]', '_' + string[0], string) %}

{{ return(string) }}

{% endmacro %}