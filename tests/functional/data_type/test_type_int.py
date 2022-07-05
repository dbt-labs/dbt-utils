import pytest
from tests.functional.data_type.base_data_type import BaseDbtUtilsBackCompat, BaseLegacyDataTypeMacro
from dbt.tests.adapter.utils.data_types.test_type_int import BaseTypeInt


class TestTypeInt(BaseDbtUtilsBackCompat, BaseTypeInt):
    pass


# previous dbt_utils code
macros__legacy_sql = """
{% macro default__type_int() %}
    int
{% endmacro %}

{% macro bigquery__type_int() %}
    int64
{% endmacro %}
"""


class TestTypeFloatLegacy(BaseLegacyDataTypeMacro, BaseTypeInt):
    @pytest.fixture(scope="class")
    def macros(self):
        return {
            "legacy.sql": macros__legacy_sql
        }
