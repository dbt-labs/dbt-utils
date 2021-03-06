{#
This calculates the distance between two sets of latitude and longitude.
The formula is from the following blog post:
http://daynebatten.com/2015/09/latitude-longitude-distance-sql/

The arguments should be float type.
#}

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

    2 * 3961 * asin(sqrt((sin(radians(({{lat2}} - {{lat1}}) / 2))) ^ 2 +
    cos(radians({{lat1}})) * cos(radians({{lat2}})) *
    (sin(radians(({{lon2}} - {{lon1}}) / 2))) ^ 2)) {{conversion_rate}}

{%- endmacro %}
