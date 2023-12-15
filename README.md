# Lakeroad Evaluation

The evaluation for [Lakeroad.](https://github.com/uwsampl/lakeroad)

This README contains detailed information on how to set up and run the evaluation. However, **the [Dockerfile](./Dockerfile)  is the first and best source of truth on which dependencies to install and environment variables to set, just as the [workflow file](.github/workflows/run-evaluation-leviathan.yml) which builds and executes it is the first and best source of truth on how to build and run the Docker image.** This README is meant to be a more readable source of information, but in case of bugs or missing information, consult the previously mentioned files.

**This evaluation must be run on a Linux machine.** Parts of the evaluation will work on Mac (namely, the Lakeroad components), but you will not be able to run (let alone install) the baseline hardware compilers (Vivado, Quartus, and Diamond).

We detail three methods for setting up and running the evaluation:
1. **Quick run via Docker.** This method will get something working quickly, but will not run the full evaluation.
2. **Full run via Docker.** This method will run the entire evaluation via Docker, and requires completing the most time-consuming part of setup: setting up the proprietary hardware design tools (Vivado, Quartus, and Diamond).
3. **Full run locally.** This method will run the entire evaluation locally, and only requires a few more dependency installations and environment variables to be set (on top of what is required for method 2.)

For those attempting to fully reproduce results, choose between methods 2 or 3. If you are working on a Linux machine (ideally Ubuntu), method 3 should work well.

For those doing development, method 3 is required.

## Quick Run via Docker

To quickly get *something* running, use the Dockerfile:

```sh
git clone --recursive <this repo>
docker build . -t lakeroad-evaluation
docker run lakeroad-evaluation
```

Note that, at the moment, this will still encounter errors when it attempts to run the proprietary baseline compilers (Vivado, Quartus, Diamond). See Setup for details on how to install those compilers and hook them into the Docker image.

TODO(@gussmith23): provide a flag for disabling proprietary tools.

## Full Run via Docker 

Our [Dockerfile](./Dockerfile) captures *almost* all of the evaluation's dependencies. However, a few critical pieces of software are left out: **the proprietary hardware compiler toolchains Vivado, Quartus, and Diamond.**

Why did we leave these out? A few reasons, but chief among them: they are very large, unwieldy to install, and may require generating individual (free) licenses.

Thus, to fully run the evaluation via Docker, you must first [install the proprietary hardware compiler toolchains.](#installing-proprietary-tools)

Once you have done this, you must now build the Docker image, passing in special `build-arg`s to point to the locations of these tools. This will look something like:

```sh
docker build . -t lakeroad-evaluation \
  --build-arg VIVADO_BIN_DIR=/path/to/Vivado/2023.1/bin \
  --build-arg QUARTUS_BIN_DIR=/path/to/quartus/bin \
  --build-arg DIAMOND_BINDIR=/path/to/diamond/3.12/bin/lin64
```

(Note: these paths actually refer to paths *inside* the Docker image, but it's encouraged to just use the same paths that exist on your host system.)

For example, in our [workflow file](.github/workflows/run-evaluation-leviathan.yml), we use the following settings for these arguments:

```sh
  ...
  --build-arg VIVADO_BIN_DIR=/tools/Xilinx/Vivado/2023.1/bin \
  --build-arg QUARTUS_BIN_DIR=/tools/intel/quartus/bin \
  --build-arg DIAMOND_BINDIR=/usr/local/diamond/3.12/bin/lin64 \
  ...
```

However, this will likely be different on your machine, depending on where you install the tools.

Finally, you can run the Docker image. In this step, we will mount your local installations of the tools into the Docker container, so that the binaries are available inside the container. We do so using `-v` flags, as follows:

```sh
docker run \
  -v /path/to/Xilinx:/path/to/Xilinx \
  -v /path/to/diamond:/path/to/diamond \
  -v /path/to/intel:/path/to/intel \
  lakeroad-evaluation
  doit --always-execute --continue -n 20
```

For example, in our [workflow file](.github/workflows/run-evaluation-leviathan.yml), we use the following settings for these arguments:

```sh
  ...
  -v /tools/Xilinx:/tools/Xilinx \
  -v /usr/local/diamond:/usr/local/diamond \
  -v /tools/intel:/tools/intel \
  ...
```

Again, these paths will be different depending on where you install these tools. **Note that we mount the entire tool folder and not just the `bin` folder;** e.g. we mount `/tools/Xilinx` instead of `/tools/Xilinx/Vivado/2023.1/bin`.

## Full Run Locally

1. Make sure submodules are cloned and up-to-date. Either clone with `--recursive`, or do `git submodule init; git submodule update`.
2. Make sure you have an up-to-date Python. We use Python 3.11.4.
3. Install Python dependencies from `requirements.txt`: `pip install -r requirements.txt`.
4. Install LLVM/Clang.
5. Install Yosys.

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

  Copy [`.env.template`](./.env.template)
    to `.env` and fill in the environment variables
    at the top of the file.
  You can then
    do `source .env`
    to set up the environment variables needed by the evaluation.
  This file is also automatically used by VSCode.

  TODO(@gussmith23): Figure out how to use Python packaging, so we could install
    the utilities as a package within a virtual environment.

Environment variables to set:

- `PYTHONPATH`
- TODO(@gussmith23): document Quartus, Diamond, Vivado

  
## Installing Proprietary Tools
  
### Vivado

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

### Lattice Diamond

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
  
### Quartus

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

## Output Location

The location of the experiment output
  can be controlled
  by setting the
  `LRE_OUTPUT_DIR` environment variable.
By default, the experiment results
  write to `out/`.
