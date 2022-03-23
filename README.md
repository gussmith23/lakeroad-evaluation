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
