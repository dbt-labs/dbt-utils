import pytest
from tests.functional.cross_db_utils.base_cross_db_macro import BaseCrossDbMacro
from tests.functional.cross_db_utils.fixture_string_literal import (
    seeds__data_string_literal_csv,
    models__test_string_literal_sql,
    models__test_string_literal_yml,
)


class BaseStringLiteral(BaseCrossDbMacro):
    @pytest.fixture(scope="class")
    def seeds(self):
        return {"data_string_literal.csv": seeds__data_string_literal_csv}

    @pytest.fixture(scope="class")
    def models(self):
        return {
            "test_string_literal.yml": models__test_string_literal_yml,
            "test_string_literal.sql": models__test_string_literal_sql,
        }


@pytest.mark.skip(reason="TODO - implement this test")
class TestStringLiteral(BaseStringLiteral):
    pass
