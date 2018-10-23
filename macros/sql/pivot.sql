{#
Pivot values from rows to columns.

Example:

    Input: `public.test`

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
    alias: Whether to create column aliases, default is True
    agg: SQL aggregation function, default is sum
    cmp: SQL value comparison, default is =
    prefix: Column alias prefix, default is blank
    suffix: Column alias postfix, default is blank
    then_value: Value to use if comparison succeeds, default is 1
    else_value: Value to use if comparison fails, default is 0
#}

{% macro pivot(column,
               values,
               alias=True,
               agg='sum',
               cmp='=',
               prefix='',
               suffix='',
               then_value=1,
               else_value=0) %}

  {% if not values %}
    {% if execute %}
      {%- set msg = "No values to pivot in column " ~ column ~ ". Pivot macro failed." -%}
      {{log(modules.datetime.datetime.now().strftime('%H:%M:%S') ~ " | " ~ msg, info=True)}}
    {% endif %}
    null as pivot_failure
  {% else %}
  {% for v in values %}
    {{ agg }}(
      case
      when {{ column }} {{ cmp }} '{{ v }}'
        then {{ then_value }}
      else {{ else_value }}
      end
    )
    {% if alias %}
      as {{ adapter.quote(prefix ~ v ~ suffix) }}
    {% endif %}
    {% if not loop.last %},{% endif %}
  {% endfor %}
  {% endif %}
{% endmacro %}
