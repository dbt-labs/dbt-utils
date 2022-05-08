import pytest
from tests.functional.cross_db_utils.base_cross_db_macro import BaseCrossDbMacro
from tests.functional.cross_db_utils.fixture_dateadd import (
    seeds__data_dateadd_csv,
    models__test_dateadd_sql,
    models__test_dateadd_yml,
)


@pytest.mark.skip_profile("bigquery", reason="TODO - need to figure out timestamp vs. datetime behavior!")
class BaseDateAdd(BaseCrossDbMacro):
    @pytest.fixture(scope="class")
    def seeds(self):
        return {"data_dateadd.csv": seeds__data_dateadd_csv}

    @pytest.fixture(scope="class")
    def models(self):
        return {
            "test_dateadd.yml": models__test_dateadd_yml,
            "test_dateadd.sql": models__test_dateadd_sql,
        }


class TestDateAdd(BaseDateAdd):
    # we do this in case an adapter will need to override the base class
    # in the simplest case, it's just:
    pass
