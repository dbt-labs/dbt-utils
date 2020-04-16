{%- macro validate_inputs(acceptable_values) %}

{# Sample usage - see the dbt docs #}

{% if not acceptable_values is iterable or acceptable_values|length == 0 %}
   {{ exceptions.raise_compiler_error("Expecting acceptable_values to contain a list of lists") }}
{% endif %}

{% for v in acceptable_values %}
 {% set error_m = "Expecting acceptable_values to contain rows of length 3 [name, var, list]. " %}
    {% if (v | length != 3) %}
      {{ exceptions.raise_compiler_error(error_m ~ "This row is of length: " (v|length) ~ "; Got row: " ~ v) }}
    {% endif %}
    {% if v[0] is not string %}
      {{ exceptions.raise_compiler_error(error_m ~ "The first argument should be a string. Got: " ~ v[0]) }}
    {% endif %}
    {% if v[2] is string %}
      {{ exceptions.raise_compiler_error(error_m ~ "The third argument should be a list of values . Got a string: '" ~ v[2] ~ "'") }}
    {% endif %}
    {% if v[2] is not iterable %}
      {{ exceptions.raise_compiler_error(error_m ~ "The third argument should be a list of values . Got: " ~ v[2]) }}
    {% endif %}

{% endfor %}



{%- for name, var, vals in acceptable_values %}
    {% set errorm = "Invalid type for `" ~ name ~ "` Expecting one of " ~ vals ~ ". Got: '" ~ var ~ "'" %}
    {% if var is undefined %}
        {%- set errorm = errorm ~ "; Maybe you used an undefined name such as TRUE, instead of the Boolean value `True`," %}
        {%- set errorm = errorm ~ " or a naked identifier such as `somestring` instead of a quoted string such as `'somestring'` " %}
    {%- endif %}
    {%- if var not in vals -%}
        {{ exceptions.raise_compiler_error(errorm) }}
    {% endif %}
{% endfor %}

{% endmacro -%}