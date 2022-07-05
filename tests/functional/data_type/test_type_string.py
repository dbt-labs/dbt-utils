import pytest
from tests.functional.data_type.base_data_type import BaseDbtUtilsBackCompat, BaseLegacyDataTypeMacro
from dbt.tests.adapter.utils.data_types.test_type_string import BaseTypeString


class TestTypeInt(BaseDbtUtilsBackCompat, BaseTypeString):
    pass


# previous dbt_utils code
macros__legacy_sql = """
{% macro default__type_string() %}
    string
{% endmacro %}

{%- macro redshift__type_string() -%}
    varchar
{%- endmacro -%}

{% macro postgres__type_string() %}
    varchar
{% endmacro %}

{% macro snowflake__type_string() %}
    varchar
{% endmacro %}
"""


class TestTypeStringLegacy(BaseLegacyDataTypeMacro, BaseTypeString):
    @pytest.fixture(scope="class")
    def macros(self):
        return {
            "legacy.sql": macros__legacy_sql
        }
