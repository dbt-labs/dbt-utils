import pytest
from tests.functional.data_type.base_data_type import BaseDbtUtilsBackCompat, BaseLegacyDataTypeMacro
from dbt.tests.adapter.utils.data_types.test_type_numeric import BaseTypeNumeric


@pytest.mark.skip_profile('bigquery')
class TestTypeNumeric(BaseDbtUtilsBackCompat, BaseTypeNumeric):
    pass


@pytest.mark.only_profile('bigquery')
class TestBigQueryTypeNumeric(BaseDbtUtilsBackCompat, BaseTypeNumeric):
    def numeric_fixture_type(self):
        return "numeric"


# previous dbt_utils code
macros__legacy_sql = """
{% macro default__type_numeric() %}
    numeric(28, 6)
{% endmacro %}
{% macro bigquery__type_numeric() %}
    numeric
{% endmacro %}
"""


class BaseTypeNumericLegacy(BaseLegacyDataTypeMacro, BaseTypeNumeric):
    @pytest.fixture(scope="class")
    def macros(self):
        return {
            "legacy.sql": macros__legacy_sql
        }


@pytest.mark.skip_profile('bigquery')
class TestTypeNumeric(BaseTypeNumeric):
    pass


@pytest.mark.skip_profile('bigquery')
class TestTypeNumericLegacy(BaseTypeNumericLegacy):
    pass


@pytest.mark.only_profile('bigquery')
class TestBigQueryTypeNumericLegacy(BaseTypeNumericLegacy):
    def numeric_fixture_type(self):
        return "numeric"
