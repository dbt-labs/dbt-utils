import os
import pytest
from dbt.tests.util import run_dbt, check_relations_equal, get_relation_columns
from dbt.tests.adapter.utils.data_types.base_data_type_macro import BaseDataTypeMacro

class BaseDbtUtilsBackCompat(BaseDataTypeMacro):
    # install this repo as a package
    @pytest.fixture(scope="class")
    def packages(self):
        return {"packages": [{"local": os.getcwd()}]}

    # call the macros from the 'dbt_utils' namespace
    # instead of the unspecified / global namespace
    def macro_namespace(self):
        return "dbt_utils"

    # actual test sequence needs to run 'deps' first
    def test_check_types_assert_match(self, project):
        run_dbt(['deps'])
        super().test_check_types_assert_match(project)


class BaseLegacyDataTypeMacro(BaseDbtUtilsBackCompat):       
    def assert_columns_equal(self, project, expected_cols, actual_cols):
        # we need to be a little more lenient when mapping between 'legacy' and 'new' types that are equivalent
        # e.g. 'character varying' and 'text'
        if expected_cols == actual_cols:
            # cool, no need for jank
            pass
        else:
            # this is pretty janky
            # our goal here: reasonable confidence that the switch from the legacy version of the dbt_utils.type_{X} macro,
            # and the new version, will not constitute a breaking change for end users
            for (expected_col, actual_col) in zip(expected_cols, actual_cols):
                expected = project.adapter.Column(*expected_col)
                actual = project.adapter.Column(*actual_col)
                print(f"Subtle type difference detected: {expected.data_type} vs. {actual.data_type}")
                if any((
                    expected.is_string() and actual.is_string(),
                    expected.is_float() and actual.is_float(),
                    expected.is_integer() and actual.is_integer(),
                    expected.is_numeric() and actual.is_numeric(),
                )):
                    pytest.xfail()
                else:
                    pytest.fail()
