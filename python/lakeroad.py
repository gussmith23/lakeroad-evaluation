"""Defines Lakeroad instruction synthesis tasks."""

import logging
import subprocess
from pathlib import Path
from time import time
from typing import List, Union

import re
import doit
import utils
import yaml
from hardware_compilation import *
from schema import *


def invoke_lakeroad(
    module_name: str,
    # TODO(@gussmith23): Give this a default value of None. Will break
    # positional uses.
    instruction: Optional[str],
    template: str,
    out_filepath: Union[str, Path],
    architecture: str,
    time_filepath: Union[str, Path],
    json_filepath: Union[str, Path],
    verilog_module_filepath: Optional[Union[str, Path]] = None,
    top_module_name: Optional[str] = None,
    verilog_module_out_signal: Optional[str] = None,
):
    """Invoke Lakeroad to generate an instruction implementation.

    The arguments to this function mostly mirror the arguments to the
    bin/main.rkt file in Lakeroad.

    Args:
      instruction: The Racket code representing the instruction. See main.rkt.
        This argument is optional; the input to Lakeroad can also be specified
        as a Verilog file in verilog_module_filepath.
      json_filepath: After this function generates the Lakeroad implementation,
        it collects information from the implementation (which later is used to
        make the tables in the paper). This is the path to write the collected
        data (in JSON format) to.
      verilog_module_filepath: The input Verilog file to compile.
      top_module_name: The name of the module to compile in the Verilog file.
      verilog_module_out_signal: The name of the output signal of the top
        module.

    TODO Could also allow users to specify whether Lakeroad should fail. E.g.
    addition isn't implemented on SOFA, so we could allow users to attempt to
    invoke Lakeroad to generate a SOFA add and expect the subprocess to
    terminate with an error code."""
    out_filepath = Path(out_filepath)

    out_filepath.parent.mkdir(parents=True, exist_ok=True)

    # TODO(@gussmith23): There is a bug in Rosette, documented here:
    # https://github.com/uwsampl/lakeroad/pull/159
    # This bug prevents us from running very specific synthesis tasks on some
    # systems. Namely, 16 bit multiplication won't synthesize on our Ubuntu
    # machine, but will synthesize on my Mac. As a temporary workaround so that
    # eval will run on our Ubuntu machine, I've run the experiments on my Mac
    # and I just output the data here. Once the bug is fixed, we should be able
    # to just remove this code.
    #     if (
    #         module_name == "lakeroad_xilinx_ultrascale_plus_mul16_2"
    #         and architecture == "xilinx-ultrascale-plus"
    #         and template == "xilinx-ultrascale-plus-dsp48e2"
    #     ):
    #         with open(out_filepath, "w") as f:
    #             f.write(
    #                 """
    # // NOTE: this file was pre-generated. See lakeroad.py for details.

    # /* Generated by Yosys 0.15+50 (git sha1 6318db615, x86_64-apple-darwin20.2-clang 10.0.0-4ubuntu1 -fPIC -Os) */

    # module lakeroad_xilinx_ultrascale_plus_mul16_2(a, b, out);
    #   wire [47:0] P_0;
    #   input [15:0] a;
    #   wire [15:0] a;
    #   input [15:0] b;
    #   wire [15:0] b;
    #   output [15:0] out;
    #   wire [15:0] out;
    #   DSP48E2 #(
    #     .ACASCREG(32'd0),
    #     .ADREG(32'd0),
    #     .ALUMODEREG(32'd0),
    #     .AMULTSEL("AD"),
    #     .AREG(32'd0),
    #     .AUTORESET_PATDET("RESET_NOT_MATCH"),
    #     .AUTORESET_PRIORITY("CEP"),
    #     .A_INPUT("DIRECT"),
    #     .BCASCREG(32'd0),
    #     .BMULTSEL("B"),
    #     .BREG(32'd0),
    #     .B_INPUT("DIRECT"),
    #     .CARRYINREG(32'd0),
    #     .CARRYINSELREG(32'd0),
    #     .CREG(32'd0),
    #     .DREG(32'd0),
    #     .INMODEREG(32'd0),
    #     .IS_ALUMODE_INVERTED(4'h0),
    #     .IS_CARRYIN_INVERTED(1'h0),
    #     .IS_CLK_INVERTED(1'h0),
    #     .IS_INMODE_INVERTED(5'h00),
    #     .IS_OPMODE_INVERTED(9'h000),
    #     .IS_RSTALLCARRYIN_INVERTED(1'h0),
    #     .IS_RSTALUMODE_INVERTED(1'h0),
    #     .IS_RSTA_INVERTED(1'h0),
    #     .IS_RSTB_INVERTED(1'h0),
    #     .IS_RSTCTRL_INVERTED(1'h0),
    #     .IS_RSTC_INVERTED(1'h0),
    #     .IS_RSTD_INVERTED(1'h0),
    #     .IS_RSTINMODE_INVERTED(1'h0),
    #     .IS_RSTM_INVERTED(1'h0),
    #     .IS_RSTP_INVERTED(1'h0),
    #     .MASK(48'h000000000000),
    #     .MREG(32'd0),
    #     .OPMODEREG(32'd0),
    #     .PATTERN(48'h000000000000),
    #     .PREADDINSEL("A"),
    #     .PREG(32'd0),
    #     .RND(48'h7fffffff0000),
    #     .SEL_MASK("ROUNDING_MODE2"),
    #     .SEL_PATTERN("C"),
    #     .USE_MULT("DYNAMIC"),
    #     .USE_PATTERN_DETECT("PATDET"),
    #     .USE_SIMD("ONE48"),
    #     .USE_WIDEXOR("FALSE"),
    #     .XORSIMD("XOR24_48_96")
    #   ) DSP48E2_0 (
    #     .A(30'h00000000),
    #     .ACIN(30'h00000000),
    #     .ALUMODE(4'hd),
    #     .B({ 2'h0, b }),
    #     .BCIN(18'h00000),
    #     .C(48'h000000000000),
    #     .CARRYCASCIN(1'h0),
    #     .CARRYIN(1'h0),
    #     .CARRYINSEL(3'h0),
    #     .CEA1(1'h1),
    #     .CEA2(1'h1),
    #     .CEAD(1'h1),
    #     .CEALUMODE(1'h1),
    #     .CEB1(1'h1),
    #     .CEB2(1'h1),
    #     .CEC(1'h1),
    #     .CECARRYIN(1'h1),
    #     .CECTRL(1'h1),
    #     .CED(1'h1),
    #     .CEINMODE(1'h1),
    #     .CEM(1'h1),
    #     .CEP(1'h1),
    #     .CLK(1'h0),
    #     .D({ 11'h000, a }),
    #     .INMODE(5'h0c),
    #     .MULTSIGNIN(1'h0),
    #     .OPMODE(9'h0b5),
    #     .P({ P_0[47:16], out }),
    #     .PCIN(48'h000000000000),
    #     .RSTA(1'h0),
    #     .RSTALLCARRYIN(1'h0),
    #     .RSTALUMODE(1'h0),
    #     .RSTB(1'h0),
    #     .RSTC(1'h0),
    #     .RSTCTRL(1'h0),
    #     .RSTD(1'h0),
    #     .RSTINMODE(1'h0),
    #     .RSTM(1'h0),
    #     .RSTP(1'h0)
    #   );
    #   assign P_0[15] = out[15];
    #   assign P_0[14] = out[14];
    #   assign P_0[13] = out[13];
    #   assign P_0[12] = out[12];
    #   assign P_0[11] = out[11];
    #   assign P_0[10] = out[10];
    #   assign P_0[9] = out[9];
    #   assign P_0[8] = out[8];
    #   assign P_0[7] = out[7];
    #   assign P_0[6] = out[6];
    #   assign P_0[5] = out[5];
    #   assign P_0[4] = out[4];
    #   assign P_0[3] = out[3];
    #   assign P_0[2] = out[2];
    #   assign P_0[1] = out[1];
    #   assign P_0[0] = out[0];
    # endmodule
    #                 """
    #             )
    #         with open(time_filepath, "w") as f:
    #             print("2.3666818141937256s", file=f)

    #         return

    cmd = [
        "racket",
        str(utils.lakeroad_evaluation_dir() / "lakeroad" / "bin" / "main.rkt"),
        "--out-format",
        "verilog",
        "--template",
        template,
        "--module-name",
        module_name,
        "--out-filepath",
        out_filepath,
        "--architecture",
        architecture,
    ]

    if instruction != None and verilog_module_filepath == None:
        # If instruction is specified and an input Verilog file isn't.
        cmd += ["--instruction", instruction]
    elif instruction == None and verilog_module_filepath != None:
        # Vice versa.
        cmd += [
            "--verilog-module-filepath",
            verilog_module_filepath,
            "--verilog-module-out-signal",
            verilog_module_out_signal,
            "--top-module-name",
            top_module_name,
        ]
    else:
        raise Exception(
            f"Didn't expect instruction ({instruction}) and verilog_module_filepath ({verilog_module_filepath})"
        )

    logging.info(
        "Generating %s with command:\n%s", out_filepath, " ".join(map(str, cmd))
    )

    try:
        start_time = time()
        subprocess.run(
            cmd,
            check=True,
        )
        end_time = time()
    except subprocess.CalledProcessError as e:
        logging.error(" " + " ".join(map(str, cmd)))
        raise e

    with open(time_filepath, "w") as f:
        print(f"{end_time-start_time}s", file=f)

    json.dump(
        count_resources_in_verilog_src(
            verilog_src=out_filepath.read_text(), module_name=module_name
        ),
        fp=open(json_filepath, "w"),
    )


@doit.task_params(
    [
        {
            "name": "experiments_file",
            "default": str(utils.lakeroad_evaluation_dir() / "experiments.yaml"),
            "type": str,
        },
    ]
)
def task_instruction_experiments(experiments_file: str):
    """DoIt task creator for compiling instructions with various backends."""

    def _make_instruction_implementation_with_lakeroad_task(
        experiment: LakeroadInstructionExperiment,
        verilog_filepath: Union[str, Path],
        time_filepath: Union[str, Path],
        json_filepath: Union[str, Path],
    ):
        instruction_str = experiment.instruction.expr
        verilog_module_name = (
            experiment.implementation_action.implementation_module_name
        )
        template = experiment.implementation_action.template

        return {
            "name": f"lakeroad_generate_{template}_{verilog_module_name}",
            "actions": [
                (
                    invoke_lakeroad,
                    [
                        verilog_module_name,
                        instruction_str,
                        template,
                        verilog_filepath,
                        experiment.architecture.replace("_", "-"),
                        time_filepath,
                    ],
                    {
                        "json_filepath": json_filepath,
                    },
                )
            ],
            # If I'm understanding DoIt correctly, then I think
            # instructions.yaml should be a dependency of these tasks, and
            # probably other things, too, i.e. the Lakeroad version. Basically,
            # we want to enable DoIt to figure out when instructions need to be
            # re-implemented with Lakeroad. That's the case when something about
            # the instruction description changes (and thus instructions.yaml
            # will be changed) or if Lakeroad itself is different.
            #
            # Note: Leaving the file_dep empty is fine; it will just re-run
            # Lakeroad on each instruction each time.
            "file_dep": [experiments_file],
            "targets": [verilog_filepath, time_filepath, json_filepath],
        }

    with open(experiments_file) as f:
        experiments: List[LakeroadInstructionExperiment] = yaml.load(f, yaml.Loader)

    for experiment in experiments:
        module_name = experiment.implementation_action.implementation_module_name
        template = experiment.implementation_action.template
        architecture = experiment.architecture

        # Base output path.
        output_dirpath = (
            utils.output_dir() / "lakeroad" / architecture / module_name / template
        )

        time_filepath = output_dirpath / f"{module_name}.time"
        verilog_filepath = output_dirpath / f"{module_name}.sv"
        json_filepath = output_dirpath / f"{module_name}.json"

        yield _make_instruction_implementation_with_lakeroad_task(
            experiment,
            time_filepath=time_filepath,
            verilog_filepath=verilog_filepath,
            json_filepath=json_filepath,
        )

        match experiment.architecture:
            case "lattice_ecp5":
                diamond_synthesis_task = make_lattice_ecp5_diamond_synthesis_task(
                    input_filepath=verilog_filepath,
                    output_dirpath=output_dirpath / "diamond",
                    module_name=module_name,
                )
                diamond_synthesis_task[
                    "name"
                ] = f"diamond_synthesize_{template}_{module_name}"
                yield diamond_synthesis_task

            case "xilinx_ultrascale_plus":
                vivado_synthesis_task = (
                    make_xilinx_ultrascale_plus_vivado_synthesis_task_noopt(
                        input_filepath=verilog_filepath,
                        module_name=module_name,
                        output_dirpath=output_dirpath / "vivado",
                    )
                )
                vivado_synthesis_task[
                    "name"
                ] = f"vivado_synthesize_{template}_{module_name}"
                yield vivado_synthesis_task

            case "sofa":
                logging.warn("No synthesis implemented for SOFA.")

            case _:
                raise Exception(
                    f"Unexpected architecture value {experiment.architecture}"
                )
