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

## [./runs](./runs)

This folder contains our output runs.
