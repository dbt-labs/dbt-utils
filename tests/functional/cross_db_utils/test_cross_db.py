import os
import pytest
from dbt.tests.util import run_dbt
from tests.functional.cross_db_utils.fixtures import (
    macros__test_assert_equal_sql,
    seeds__data_dateadd_csv,
    models__test_dateadd_sql,
    models__test_dateadd_yml,
    seeds__data_datediff_csv,
    models__test_datediff_sql,
    models__test_datediff_yml,
)


class BaseCrossDbMacro:
    # install this repo as a package!
    @pytest.fixture(scope="class")
    def packages(self):
        return {"packages": [{"local": os.getcwd()}]}

    # setup
    @pytest.fixture(scope="class")
    def macros(self):
        return {"test_assert_equal.sql": macros__test_assert_equal_sql}
    
    # each child class will reimplement 'models' + 'seeds'
    def seeds(self):
        return {}
        
    def models(self):
        return {}

    # actual test sequence
    def test_build_assert_equal(self, project):
        run_dbt(['deps'])
        run_dbt(['build'])    # seed, model, test -- all handled by dbt


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


class BaseDateDiff(BaseCrossDbMacro):
    @pytest.fixture(scope="class")
    def seeds(self):
        return {"data_datediff.csv": seeds__data_datediff_csv}

    @pytest.fixture(scope="class")
    def models(self):
        return {
            "test_datediff.yml": models__test_datediff_yml,
            "test_datediff.sql": models__test_datediff_sql,
        }


class TestDateDiff(BaseDateDiff):
    pass
