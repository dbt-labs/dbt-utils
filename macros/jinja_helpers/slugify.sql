{% macro slugify(string) %}

{% if not string %}
{{ return('') }}
{% endif %}

{#- Lower case the string -#}
{% set string = string | lower %}
{#- Replace spaces and dashes with underscores -#}
{% set string = modules.re.sub('[ -]+', '_', string) %}
{#- Only take letters, numbers, and underscores -#}
{% set string = modules.re.sub('[^a-z0-9_]+', '', string) %}
{#- Prepends "_" if string begins with a number -#}
{% set string = modules.re.sub('^[0-9]', '_' + string[0], string) %}

{{ return(string) }}

{% endmacro %}
