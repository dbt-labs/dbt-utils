import pytest
from tests.functional.data_type.base_data_type import BaseDbtUtilsBackCompat, BaseLegacyDataTypeMacro
from dbt.tests.adapter.utils.data_types.test_type_timestamp import BaseTypeTimestamp


class TestTypeTimestamp(BaseDbtUtilsBackCompat, BaseTypeTimestamp):
    pass


# previous dbt_utils code
macros__legacy_sql = """
{% macro default__type_timestamp() %}
    timestamp
{% endmacro %}

{% macro postgres__type_timestamp() %}
    timestamp without time zone
{% endmacro %}

{% macro snowflake__type_timestamp() %}
    timestamp_ntz
{% endmacro %}
"""


class TestTypeTimestampLegacy(BaseLegacyDataTypeMacro, BaseTypeTimestamp):
    @pytest.fixture(scope="class")
    def macros(self):
        return {
            "legacy.sql": macros__legacy_sql
        }
