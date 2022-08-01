# Lakeroad Evaluation

```sh
git clone --recursive <this repo>
docker build . -t lakeroad-evaluation
docker run lakeroad-evaluation
```

## Dependencies

See the Dockerfile for a definitive list of dependencies. We give some additional detail here.

- yosys 0.15
  - The most up-to-date yosys can be downloaded as part of the [OSS CAD Suite](https://github.com/YosysHQ/oss-cad-suite-build/releases).
    yosys installed via some package managers will be out of date.

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

1. Pass `--build-arg VIVADO_SETTINGS64_SH=</absolute/path/to/settings64.sh>`
    to `docker build`.
    The absolute path should be the path on the container,
      not on the host, though we recommend that you ensure
      that the paths are the same. See step 2.
    This will ensure that`settings64.sh` is sourced in the Docker image's `.bashrc`.
    You can also manually source this file yourself when running in a container.
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
