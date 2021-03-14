{#
This calculates the distance between two sets of latitude and longitude.
The formula is from the following blog post:
http://daynebatten.com/2015/09/latitude-longitude-distance-sql/

The arguments should be float type.
#}

{% macro degrees_to_radians(degrees) -%}
    acos(-1) * {{degrees}} / 180
{%- endmacro %}

{% macro haversine_distance(lat1,lon1,lat2,lon2,unit='mi') -%}
    {{ return(adapter.dispatch('haversine_distance', packages = dbt_utils._get_utils_namespaces())(lat1,lon1,lat2,lon2,unit)) }}
{% endmacro %}

{% macro default__haversine_distance(lat1,lon1,lat2,lon2,unit) -%}
{# vanilla macro is in miles #}
    {% set conversion_rate = '' %}
{% if unit == 'km' %}
{# we multiply miles result to get it in kms #}
    {% set conversion_rate = '* 1.60934' %}
{% endif %}

    2 * 3961 * asin(sqrt(pow((sin(radians(({{lat2}} - {{lat1}}) / 2))), 2) +
    cos(radians({{lat1}})) * cos(radians({{lat2}})) *
    pow((sin(radians(({{lon2}} - {{lon1}}) / 2))), 2))) {{conversion_rate}}

{%- endmacro %}



{% macro bigquery__haversine_distance(lat1,lon1,lat2,lon2,unit) -%}
{% set r_lat1 = dbt_utils.degrees_to_radians(lat1) %}
{% set r_lat2 = dbt_utils.degrees_to_radians(lat2) %}
{% set r_lon1 = dbt_utils.degrees_to_radians(lon1) %}
{% set r_lon2 = dbt_utils.degrees_to_radians(lon2) %}
{# vanilla macro is in miles #}
    {% set conversion_rate = '' %}
{% if unit == 'km' %}
{# we multiply miles result to get it in kms #}
    {% set conversion_rate = '* 1.60934' %}
{% endif %}

    2 * 3961 * asin(sqrt(pow(sin(({{r_lat2}} - {{r_lat1}}) / 2), 2) +
    cos({{r_lat1}}) * cos({{r_lat2}}) *
    pow(sin(({{r_lon2}} - {{r_lon1}}) / 2), 2))) {{conversion_rate}}

{%- endmacro %}

