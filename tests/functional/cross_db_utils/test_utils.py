import os
import pytest
from dbt.tests.util import run_dbt
from dbt.tests.adapter.utils.base_utils import BaseUtils
from dbt.tests.adapter.utils.test_dateadd import BaseDateAdd
from dbt.tests.adapter.utils.test_datediff import BaseDateDiff


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
class TestDateAdd(BaseDbtUtilsBackCompat, BaseDateAdd):
    pass


class TestDateDiff(BaseDbtUtilsBackCompat, BaseDateDiff):
    pass
