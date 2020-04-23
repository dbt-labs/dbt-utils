{#- 

The ANSI `GREATEST` function returns NULL if _any_ argument is null.

This macro generates an expression such that the largest non-null value is returned.

If all fields are null, then null is returned.

EXAMPLES:

Assume the following 1-row table exists:
```
CREATE TEMP TABLE stuff AS (SELECT 1 AS a, 2 AS b, NULL::INT as c, NULL::INT as d);
```

`SELECT {{nullsafe_least(["a","b","c","d"])}} FROM stuff` returns `2` because 1 is the largest input

`SELECT {{nullsafe_least(["c","d"])}} FROM stuff` returns `NULL` because all inputs are null. 

-#}

{% macro nullsafe_greatest(args) -%}
GREATEST(
    {%- for field in args -%}
        {%- set coalesce_args = ([field] + args) | join(',') -%}
        {%- if not loop.first%}, {% endif -%}
        COALESCE({{- coalesce_args -}})
    {%- endfor -%}
)

{%- endmacro -%}
