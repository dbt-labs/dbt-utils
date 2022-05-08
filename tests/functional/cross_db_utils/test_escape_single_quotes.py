import pytest
from tests.functional.cross_db_utils.base_cross_db_macro import BaseCrossDbMacro
from tests.functional.cross_db_utils.fixture_escape_single_quotes import (
    seeds__data_escape_single_quotes_csv,
    models__test_escape_single_quotes_sql,
    models__test_escape_single_quotes_yml,
)


class BaseEscapeSingleQuotes(BaseCrossDbMacro):
    @pytest.fixture(scope="class")
    def seeds(self):
        return {"data_escape_single_quotes.csv": seeds__data_escape_single_quotes_csv}

    @pytest.fixture(scope="class")
    def models(self):
        return {
            "test_escape_single_quotes.yml": models__test_escape_single_quotes_yml,
            "test_escape_single_quotes.sql": models__test_escape_single_quotes_sql,
        }


@pytest.mark.skip(reason="TODO - implement this test")
class TestEscapeSingleQuotes(BaseEscapeSingleQuotes):
    pass
