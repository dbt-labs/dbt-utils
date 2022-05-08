import pytest
from tests.functional.cross_db_utils.base_cross_db_macro import BaseCrossDbMacro
from tests.functional.cross_db_utils.fixture_except import (
    seeds__data_except_csv,
    models__test_except_sql,
    models__test_except_yml,
)


class BaseExcept(BaseCrossDbMacro):
    @pytest.fixture(scope="class")
    def seeds(self):
        return {"data_except.csv": seeds__data_except_csv}

    @pytest.fixture(scope="class")
    def models(self):
        return {
            "test_except.yml": models__test_except_yml,
            "test_except.sql": models__test_except_sql,
        }


@pytest.mark.skip(reason="TODO - implement this test")
class TestExcept(BaseExcept):
    pass
