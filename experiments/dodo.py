"""Main dodo file for DoIt. Imports all DoIt tasks so they are visible."""
from generate_impls_doit import task_generate_impls
from compile_instructions_doit import task_compile_instrs
from run_calyx_tests_doit import task_run_calyx_tests
from calyx_end_to_end_doit import (task_xilinx_ultrascale_plus_calyx_end_to_end, task_lattice_ecp5_calyx_end_to_end, task_vanilla_calyx_end_to_end)