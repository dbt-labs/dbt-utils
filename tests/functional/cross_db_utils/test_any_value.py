import pytest
from tests.functional.cross_db_utils.base_cross_db_macro import BaseCrossDbMacro
from tests.functional.cross_db_utils.fixture_any_value import (
    seeds__data_any_value_csv,
    models__test_any_value_sql,
    models__test_any_value_yml,
)


class BaseAnyValue(BaseCrossDbMacro):
    @pytest.fixture(scope="class")
    def seeds(self):
        return {"data_any_value.csv": seeds__data_any_value_csv}

    @pytest.fixture(scope="class")
    def models(self):
        return {
            "test_any_value.yml": models__test_any_value_yml,
            "test_any_value.sql": models__test_any_value_sql,
        }


class TestAnyValue(BaseAnyValue):
    pass
