{#
    This macro is copied and slightly edited from the dbt_expectations package.
    At the time of this addition, dbt_expectations couldn't be added because
    integration_tests is installing dbt_utils from local without a hard-coded
    path. dbt is not able to resolve duplicate dependencies of dbt_utils
    due to this.
#}

{%- test expect_table_columns_to_match_set(model, column_list, transform="upper") -%}
{%- if execute -%}
    {%- set column_list = column_list | map(transform) | list -%}

    {# Replaces dbt_expectations._get_column_list() #}
    {%- set relation_column_names = adapter.get_columns_in_relation(model)
                                    | map(attribute="name")
                                    | map(transform)
                                    | list
    -%}

    {# Replaces dbt_expectations._list_intersect() #}
    {%- set matching_columns = [] -%}
    {%- for itm in column_list -%}
        {%- if itm in relation_column_names -%}
            {%- do matching_columns.append(itm) -%}
        {%- endif -%}
    {%- endfor -%}

    with relation_columns as (

        {% for col_name in relation_column_names %}
        select cast('{{ col_name }}' as {{ type_string() }}) as relation_column
        {% if not loop.last %}union all{% endif %}
        {% endfor %}
    ),
    input_columns as (

        {% for col_name in column_list %}
        select cast('{{ col_name }}' as {{ type_string() }}) as input_column
        {% if not loop.last %}union all{% endif %}
        {% endfor %}
    )
    select *
    from
        relation_columns r
        full outer join
        input_columns i on r.relation_column = i.input_column
    where
        -- catch any column in input list that is not in the list of table columns
        -- or any table column that is not in the input list
        r.relation_column is null or
        i.input_column is null

{%- endif -%}
{%- endtest -%}
