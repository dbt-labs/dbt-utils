{#-
This query returns a list of column names. This is particularly useful when you
need the column names from a CTE (e.g. an ephemeral model), rather than a relation
(i.e. a view or table) since the
Note that it only returns column_names, and not a Column object
-#}
{%- macro get_column_names_from_sql(query_sql) -%}

{%- set query_sql_limit_0 -%}
with query_sql as (
    {{ query_sql }}
)

select * from query_sql
limit 0

{%- endset -%}

{%- set results = run_query(query_sql_limit_0) -%}

{%- if execute -%}

{{- return(results.column_names) -}}

{%- else -%}

{{- return([]) -}}

{%- endif -%}

{%- endmacro -%}
