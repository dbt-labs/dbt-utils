{#
    This macro replicates the python zip operation in order to iterate through two lists at the same time. 

    example usage:
    {% set list_1 = ['do', 'analytics', 'with' ] %}
    {% set list_2 = ['your', 'engineering', 'dbt' ] %}

    {{ zip_lists(list_1, list_2) }}

    >> [('do', 'your'), ('analytics', 'engineering'), ('with', 'dbt')]

#}

{%- macro zip_lists(list_1, list_2) -%}

    {% if list_1 | length != list_2 | length %}
        {% set error_message = '
        Lists called in macro zip_lists() are of different lengths. \
        Check the SQL in {}.{} to address this issue.'.format(model.package_name, model.name)
        %}
        {% do exceptions.warn(error_message) %}
    {% endif %}

    {%- set output = [] -%}

    {%- for item in list_1 -%}

        {%- set pair = (list_1[loop.index0], list_2[loop.index0]) -%}
        {%- do output.append(pair) -%}
        
    {%- endfor -%}

    {% do return(output) %}
  
{%- endmacro -%}