import pytest
from tests.functional.cross_db_utils.base_cross_db_macro import BaseCrossDbMacro
from tests.functional.cross_db_utils.fixture_escape_single_quotes import (
    models__test_escape_single_quotes_sql,
    models__test_escape_single_quotes_sql_snowflake_bigquery,
    models__test_escape_single_quotes_yml,
)


class BaseEscapeSingleQuotes(BaseCrossDbMacro):
    @pytest.fixture(scope="class")
    def models(self):
        return {
            "test_escape_single_quotes.yml": models__test_escape_single_quotes_yml,
            "test_escape_single_quotes.sql": models__test_escape_single_quotes_sql,
        }


@pytest.mark.only_profile("postgres")
class TestEscapeSingleQuotesPostgres(BaseEscapeSingleQuotes):
    pass


@pytest.mark.only_profile("redshift")
class TestEscapeSingleQuotesRedshift(BaseEscapeSingleQuotes):
    pass


@pytest.mark.only_profile("snowflake")
class TestEscapeSingleQuotesSnowflake(BaseEscapeSingleQuotes):
    def models(self):
        return {
            "test_escape_single_quotes.yml": models__test_escape_single_quotes_yml,
            "test_escape_single_quotes.sql": models__test_escape_single_quotes_sql_snowflake_bigquery,
        }

@pytest.mark.only_profile("bigquery")
class TestEscapeSingleQuotesBigQuery(BaseEscapeSingleQuotes):
    def models(self):
        return {
            "test_escape_single_quotes.yml": models__test_escape_single_quotes_yml,
            "test_escape_single_quotes.sql": models__test_escape_single_quotes_sql_snowflake_bigquery,
        }
