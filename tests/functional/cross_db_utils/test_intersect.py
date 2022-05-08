import pytest
from tests.functional.cross_db_utils.base_cross_db_macro import BaseCrossDbMacro
from tests.functional.cross_db_utils.fixture_intersect import (
    seeds__data_intersect_csv,
    models__test_intersect_sql,
    models__test_intersect_yml,
)


class BaseIntersect(BaseCrossDbMacro):
    @pytest.fixture(scope="class")
    def seeds(self):
        return {"data_intersect.csv": seeds__data_intersect_csv}

    @pytest.fixture(scope="class")
    def models(self):
        return {
            "test_intersect.yml": models__test_intersect_yml,
            "test_intersect.sql": models__test_intersect_sql,
        }


@pytest.mark.skip(reason="TODO - implement this test")
class TestIntersect(BaseIntersect):
    pass
