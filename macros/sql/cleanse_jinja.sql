{% macro cleanse_jinja(text) -%}
{#
Clean templated text outputs, so that it is compilable without quote identifiers

Arguments:
    text: text_to_clean
#}

        {{text.lower()|replace(" ", "_")|replace("/", "or")|replace("-", "to")|replace(">", "above")|replace("<", "below")|replace(",", "")|replace(".", "")|replace(",", "")|replace("=", "")|replace("(", "")|replace(")", "")|replace("'", "")|replace("!", "")|replace("@", "")|replace("$", "")|replace("%", "")|replace("&", "and")|replace("+", "plus") }}

{%- endmacro %}
