import pytest
from tests.functional.data_type.base_data_type import BaseDbtUtilsBackCompat, BaseLegacyDataTypeMacro
from dbt.tests.adapter.utils.data_types.test_type_float import BaseTypeFloat


class TestTypeFloat(BaseDbtUtilsBackCompat, BaseTypeFloat):
    pass


# previous dbt_utils code
macros__legacy_sql = """
{% macro default__type_float() %}
    float
{% endmacro %}

{% macro bigquery__type_float() %}
    float64
{% endmacro %}
"""


class TestTypeFloatLegacy(BaseLegacyDataTypeMacro, BaseTypeFloat):
    @pytest.fixture(scope="class")
    def macros(self):
        return {
            "legacy.sql": macros__legacy_sql
        }
