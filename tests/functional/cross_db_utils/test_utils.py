import os
import pytest
from dbt.tests.util import run_dbt
from dbt.tests.adapter.utils.base_utils import BaseUtils
from dbt.tests.adapter.utils.test_any_value import BaseAnyValue
from dbt.tests.adapter.utils.test_bool_or import BaseBoolOr
from dbt.tests.adapter.utils.test_cast_bool_to_text import BaseCastBoolToText
from dbt.tests.adapter.utils.test_concat import BaseConcat
from dbt.tests.adapter.utils.test_dateadd import BaseDateAdd
from dbt.tests.adapter.utils.test_datediff import BaseDateDiff
from dbt.tests.adapter.utils.test_date_trunc import BaseDateTrunc
from dbt.tests.adapter.utils.test_escape_single_quotes import BaseEscapeSingleQuotesQuote
from dbt.tests.adapter.utils.test_escape_single_quotes import BaseEscapeSingleQuotesBackslash
from dbt.tests.adapter.utils.test_except import BaseExcept
from dbt.tests.adapter.utils.test_hash import BaseHash
from dbt.tests.adapter.utils.test_intersect import BaseIntersect
from dbt.tests.adapter.utils.test_last_day import BaseLastDay
from dbt.tests.adapter.utils.test_length import BaseLength
from dbt.tests.adapter.utils.test_listagg import BaseListagg
from dbt.tests.adapter.utils.test_position import BasePosition
from dbt.tests.adapter.utils.test_replace import BaseReplace
from dbt.tests.adapter.utils.test_right import BaseRight
from dbt.tests.adapter.utils.test_safe_cast import BaseSafeCast
from dbt.tests.adapter.utils.test_split_part import BaseSplitPart
from dbt.tests.adapter.utils.test_string_literal import BaseStringLiteral


class BaseDbtUtilsBackCompat(BaseUtils):
    # install this repo as a package
    @pytest.fixture(scope="class")
    def packages(self):
        return {"packages": [{"local": os.getcwd()}]}

    # call the macros from the 'dbt_utils' namespace
    # instead of the unspecified / global namespace
    def macro_namespace(self):
        return "dbt_utils"

    # actual test sequence needs to run 'deps' first
    def test_build_assert_equal(self, project):
        run_dbt(['deps'])
        super().test_build_assert_equal(project)


# order matters for this multiple inheritance: leftmost "wins"
# prioritize this package's macros
class TestAnyValue(BaseDbtUtilsBackCompat, BaseAnyValue):
    pass


class TestBoolOr(BaseDbtUtilsBackCompat, BaseBoolOr):
    pass


class TestCastBoolToText(BaseDbtUtilsBackCompat, BaseCastBoolToText):
    pass


class TestConcat(BaseDbtUtilsBackCompat, BaseConcat):
    pass


class TestDateAdd(BaseDbtUtilsBackCompat, BaseDateAdd):
    pass


class TestDateDiff(BaseDbtUtilsBackCompat, BaseDateDiff):
    pass


class TestDateTrunc(BaseDbtUtilsBackCompat, BaseDateTrunc):
    pass


@pytest.mark.only_profile("postgres")
class TestEscapeSingleQuotesPostgres(BaseDbtUtilsBackCompat, BaseEscapeSingleQuotesQuote):
    pass


@pytest.mark.only_profile("redshift")
class TestEscapeSingleQuotesRedshift(BaseDbtUtilsBackCompat, BaseEscapeSingleQuotesQuote):
    pass


@pytest.mark.only_profile("snowflake")
class TestEscapeSingleQuotesSnowflake(BaseDbtUtilsBackCompat, BaseEscapeSingleQuotesBackslash):
    pass


@pytest.mark.only_profile("bigquery")
class TestEscapeSingleQuotesBigQuery(BaseDbtUtilsBackCompat, BaseEscapeSingleQuotesBackslash):
    pass


class TestExcept(BaseDbtUtilsBackCompat, BaseExcept):
    pass


class TestHash(BaseDbtUtilsBackCompat, BaseHash):
    pass


class TestIntersect(BaseDbtUtilsBackCompat, BaseIntersect):
    pass


class TestLastDay(BaseDbtUtilsBackCompat, BaseLastDay):
    pass


class TestLength(BaseDbtUtilsBackCompat, BaseLength):
    pass


class TestListagg(BaseDbtUtilsBackCompat, BaseListagg):
    pass


class TestPosition(BaseDbtUtilsBackCompat, BasePosition):
    pass


class TestReplace(BaseDbtUtilsBackCompat, BaseReplace):
    pass


class TestRight(BaseDbtUtilsBackCompat, BaseRight):
    pass


class TestSafeCast(BaseDbtUtilsBackCompat, BaseSafeCast):
    pass


class TestSplitPart(BaseDbtUtilsBackCompat, BaseSplitPart):
    pass


class TestStringLiteral(BaseDbtUtilsBackCompat, BaseStringLiteral):
    pass
