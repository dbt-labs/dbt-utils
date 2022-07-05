import pytest
from tests.functional.data_type.base_data_type import BaseDbtUtilsBackCompat, BaseLegacyDataTypeMacro
from dbt.tests.adapter.utils.data_types.test_type_bigint import BaseTypeBigInt


class TestTypeBigInt(BaseDbtUtilsBackCompat, BaseTypeBigInt):
    pass


# previous dbt_utils code
macros__legacy_sql = """
{% macro default__type_bigint() %}
    bigint
{% endmacro %}

{% macro bigquery__type_bigint() %}
    int64
{% endmacro %}
"""

class TestTypeBigIntLegacy(BaseLegacyDataTypeMacro, BaseTypeBigInt):
    @pytest.fixture(scope="class")
    def macros(self):
        return {
            "legacy.sql": macros__legacy_sql
        }
