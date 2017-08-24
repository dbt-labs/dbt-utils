/*
bigquery:
SELECT FIRST(SPLIT(path, '/')) part1,
       NTH(2, SPLIT(path, '/')) part2,
       NTH(3, SPLIT(path, '/')) part3
FROM (SELECT "/a/b/aaaa?c" path)


redshift:
SPLIT_PART(string, delimiter, part)

postgres:
split_part(string text, delimiter text, field int)

snowflake:
SPLIT_PART(<string>, <delimiter>, <partNr>)

looks like there is a clear default and bq is different
*/


{% macro split_part(string_text, delimiter_text, part_number) %}
  {{ adapter_macro('split_part', string_text, delimiter_text, part_number) }}
{% endmacro %}


{% macro default__split_part(string_text, delimiter_text, part_number) %}

    split_part(
        {{ string_text }},
        {{ delimiter_text }},
        {{ part_number }}
        )

{% endmacro %}


{% macro bigquery__split_part(string_text, delimiter_text, part_number) %}

    split(
        {{ string_text }},
        {{ delimiter_text }}
        )[offset({{ part_number - 1 }})]

{% endmacro %}
