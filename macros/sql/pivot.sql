{# 
Pivot values from rows to columns.

Example:

    Input: 'public.test'

    | size | color |
    |------+-------|
    | S    | red   |
    | S    | blue  |
    | S    | red   |
    | M    | red   |

    select
      size,
      {{ dbt_utils.pivot('color', dbt_utils.get_column_values('public.test',
                                                              'color')) }}
    from public.test
    group by size

    Output:

    | size | red | blue |
    |------+-----+------|
    | S    | 2   | 1    |
    | M    | 1   | 0    |

Arguments:
    column: Column name, required
    values: List of row values to turn into columns, required
    excluded_values: list of values you do not want pivoted. This should be 
                     passed in parentheses ie excluded_values=('foo','bar'). 
                     default is ['']
    alias: Whether to create column aliases, default is True
    coalesce: Whether the whole statement should coalesce to 0 
              ie coalesce(agg(case),0) default is False
    agg: SQL aggregation function, default is sum
    total: Whether all values (except excluded) should be summed for 
           a total column. default is False
    distinct: Whether vals in the agg should be distinct ie count(distinct).
           default is False
    cmp: SQL value comparison, default is =
    prefix: Column alias prefix, default is blank
    suffix: Column alias postfix, default is blank
    then_value: Value to use if comparison succeeds, default is 1
    else_value: Value to use if comparison fails, default is 0
#}

{% macro pivot(column,
               values,
               excluded_values=[''],
               alias=True,
               distinct=False,
               coalesce=False,
               total=False,
               agg='sum',
               cmp='=',
               prefix='',
               suffix='',
               then_value=1,
               else_value='null') %}
  
  {%- set filtered_list=[] -%}
  {%- for v in values -%}    
    {%- if v|string not in excluded_values -%}
      {%- set a= filtered_list.append(v) -%}    
    {%- endif -%}
  {%- endfor -%}    

  
  {% for v in filtered_list %}    
      {%- if not loop.first -%},{%- endif -%}     
      {%- if coalesce -%} coalesce( {%- endif -%}

      {{ agg }}({% if distinct %} distinct {% endif %}
        case
        when {{ column }} {{ cmp }} '{{ v }}'
          then {{ then_value }}
        else {{ else_value }}
        end
      ) {% if coalesce %} ,0) {% endif %}
      {% if alias %} as {{ adapter.quote(prefix ~ v ~ suffix)|replace('-','_') }} {% endif %}
  {% endfor %}
  
  {%- if total -%}
      ,{% if coalesce %} coalesce( {% endif %}{{ agg }}({% if distinct %} distinct {% endif %} 
      case
      when {{ column }} not in ( 
        {%- for ev in excluded_values -%} 
          '{{ ev }}' 
          {%- if not loop.last -%},{%- endif -%} 
        {% endfor %})
        then {{ then_value }}
      else {{ else_value }}
      end
      ) {% if coalesce %} ,0) {% endif %}
      {% if alias %} as {{ adapter.quote(prefix ~ 'total' ~ suffix)|replace('-','_') }}{% endif %}
  {%- endif -%}
{% endmacro %}
