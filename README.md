# Lakeroad Evaluation

**Quick run on Docker:**

```sh
git clone --recursive <this repo>
docker build . -t lakeroad-evaluation
docker run lakeroad-evaluation
```

**Run locally:** *Requires dependencies to be set up.* TODO(@gussmith23)

TODO(@gussmith23): quick run w/o Vivado.

## Setup

See the Dockerfile for a definitive list of dependencies to install.
We give some additional detail here.

- yosys 0.15
  - The most up-to-date yosys can be downloaded as part of the [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build/releases).
    yosys installed via some package managers will be out of date.

- Lakeroad Evaluation Python library
  This evaluation is built on top of a small Python library,
    located in [`/python`](/python/).
  If you would like to run some or all of the evaluation,
    you will need to make sure
    the library is visible
    by the evaluation scripts.
  This can be achieved by
    adding the Python directory to your `PYTHONPATH` directly:

  ```sh
  export PYTHONPATH="$PWD/python:$PYTHONPATH"
  ```

  When developing in VSCode,
    it can also be useful
    to create an `.env` file
    at the root of the project
    which looks like:

  ```sh
  $ cat .env
  PYTHONPATH=./python:${env:PYTHONPATH}
  ```

  This will tell VSCode to add the library to the `PYTHONPATH`

  TODO(@gussmith23): Figure out how to use Python packaging, so we could install
    the utilities as a package within a virtual environment.

## Output Location

The location of the experiment output
  can be controlled
  by setting the
  `OUTPUT_DIR` environment variable.
By default, the experiment results
  write to `out/`.

## Design

Conceptually, our evaluation is
  a tree of experiments.
There is one root/top-level experiment,
  which has a number of sub-experiments;
  sub-experiments can also have sub-experiments,
  thus forming a tree.

Practically, each experiment is a Python script.
The root/top-level experiment
  is in [`/run.py`](/run.py).
This experiment
  then calls in to the sub-experiment scripts
  defined in [`/experiments/`](/experiments/).
Each sub-experiment
  in [`/experiments/`](/experiments/)
  is also a freestanding script which can be run individually.

The `Experiment` class itself is defined in
  [`/python/experiment.py`](/python/experiment.py).
Please see the documentation in that file to understand
  the design of the class,
  and refer to the various experiments
  in [`/experiments/`](/experiments/)
  for examples of how to use the class.
  
## Calyx

We have multiple versions of Calyx in the repository.
[`calyx/`](./calyx/) is "vanilla", unmodified Calyx.
We also have versions of Calyx which use our implementations of their ISA:
  e.g.
  [`calyx-xilinx-ultrascale-plus/`](./calyx-xilinx-ultrascale-plus/), for UltraScale+.
These versions of Calyx
  work the same as Calyx on the surface,
  but under the hood,
  they compile to our architecture-specific
  structural SystemVerilog,
  rather than the behavioral SystemVerilog
  which Calyx usually compiles to.

## Vivado

The evaluation optionally depends
  on Vivado.
The [`run.sh`](/run.sh) script
  has a flag for controlling whether
  the Vivado-based tests are run.

The Docker image can use the Vivado installed on your system.
There are two steps to this process:

1. Pass `--build-arg VIVADO_BIN_DIR=</absolute/path/to/vivado/bin>`
    to `docker build`.
    The absolute path should be the path on the container,
      not on the host, though we recommend that you ensure
      that the paths are the same. See step 2.
    This will add the bin directory to the path.
2. During `docker run`, mount your entire Xilinx software directory. For example, our
    directory looks like:

    ```raw
    $ tree -d -L 2 /tools/Xilinx
    /tools/Xilinx
    ├── DocNav
    │   ├── lib
    │   ├── libexec
    │   ├── pdfjs
    │   ├── plugins
    │   ├── resources
    │   └── translations
    ├── Downloads
    ├── Model_Composer
    │   └── 2021.2
    ├── Vitis_HLS
    │   └── 2021.2
    ├── Vivado
    │   └── 2021.2
    └── xic
        ├── bin
        ├── data
        ├── lib
        ├── scripts
        └── tps
    ```

    We mount the directory during `docker run` as follows:

    ```shell
    docker run -v /tools/Xilinx/:/tools/Xilinx/ lakeroad-evaluation ...
    ```

    We recommend preserving the exact directory structure that exists on the host machine.
    Thus, in our case, we map `/tools/Xilinx` to `/tools/Xilinx`.
    This is because some of the tools have hardcoded directories.

Once the environment is set up correctly, you should be able
  to run the evaluation scripts
  with Vivado-based eval enabled.

## [./runs](./runs)

This folder contains our output runs.
