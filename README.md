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

## Environment Variables to Set

- `PYTHONPATH`
- TODO(@gussmith23): document Quartus, Diamond, Vivado

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

[`calyx_base`](./calyx_base/)
  contains the base set of modifications
  which all of our other Calyx versions
  are based off of.

[`calyx_vivado`](./calyx_vivado//)
  is Calyx using instructions pre-implemented
  for Xilinx UltraScale+
  using Vivado.

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

## Lattice Diamond

*Summary:* To enable the use of Lattice Diamond,
  set the `DIAMOND_BINDIR` environment variable when running locally,
  and use the `DIAMOND_BINDIR` build argument
  when building and running in the Docker container.

The evaluation optionally depends
  on Lattice Diamond.
We do not install Diamond in the Docker image
  due to its license,
  so we expect the user to install it
  on the host system,
  and mount it into the container.

Diamond
  can be downloaded
  [here](https://www.latticesemi.com/latticediamond).
Lattice Diamond requires a license,
  but most people can get a free license from their website.
See [this page](https://www.latticesemi.com/en/Support/Licensing).
For those on Ubuntu, the Linux version
  of Diamond
  can be made to work with Ubuntu.
See [this tutorial](https://community.element14.com/technologies/fpga-group/b/blog/posts/getting-started-with-the-tinyfpga-lattice-diamond-3-12-on-ubuntu-18-04).

The evaluation does not expect
  Diamond to be available on the `PATH`,
  as Diamond's libraries can interfere with system libraries.
Instead, the evaluation expects the user to set
  the `DIAMOND_BINDIR`
  environment variable
  to the location of the directory
  of Diamond binaries,
  e.g. `/usr/local/diamond/3.12/bin/lin64`.
  
There are two steps
  to enabling Lattice Diamond
  inside the Docker image:

1. Build this repo's Docker image with `--build-arg=DIAMOND_BINDIR=/path/to/diamond/bindir`.
2. Mount the host's Diamond directory when running the Docker container.

When building the Docker image,
  set the `DIAMOND_BINDIR` build argument.
This argument should point to the main folder of Diamond binaries.
How you set this variable is determined
  by where you mount
  the Diamond directory
  in the next step.
If we are on Linux, and our Diamond directory
  on the host
  is `/usr/local/diamond`,
  and we mount it to
  `/usr/local/diamond`
  in our container,
  then we will set `DIAMOND_BINDIR` with:
  `--build-arg=DIAMOND_BINDIR=/usr/local/diamond/3.12/bin/lin64`.

Lastly,
  we need to mount
  our Diamond directory
  into the container
  when we finally run the Docker image.
To do so, we use the following syntax:
  `docker run -v/usr/local/diamond:/usr/local/diamond ...`,
  replacing `/usr/local/diamond` with the path
  to your Diamond installation.
  
## Quartus

Similarly to Vivado and Diamond,
  the evaluation depends on Quartus.
A free version of Quartus can be downloaded
  from Intel's website.
Quartus must appear on the `PATH`.
In the future, it would be ideal to
  (1) make Quartus optional and
  (2) specify its location via an environment variable.
Quartus must similarly also be mounted into the Docker container.
See [`.github/workflows/run-evaluation.yml`](./.github/workflows/run-evaluation.yml)
  for an example invocation of the Docker container.

## [./runs](./runs)

This folder contains our output runs.
