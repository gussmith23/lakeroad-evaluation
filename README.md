# Lakeroad Evaluation <!-- omit from toc -->

This README contains detailed information on how to set up and run the evaluation
  for [Lakeroad](https://github.com/uwsampl/lakeroad).
It was specifically written
  for ASPLOS 2024's artifact evaluation process,
  but all instructions should work
  for the general public.

## Table of Contents <!-- omit from toc -->

- [Introduction](#introduction)
- [Step 0: Kick the Tires](#step-0-kick-the-tires)
- [Step 1: Install Proprietary Hardware Tools](#step-1-install-proprietary-hardware-tools)
  - [Xilinx Vivado](#xilinx-vivado)
  - [Lattice Diamond](#lattice-diamond)
  - [Intel Quartus](#intel-quartus)
- [Step 2: Build Docker Image](#step-2-build-docker-image)
- [Step 3: Run Evaluation](#step-3-run-evaluation)
  - [Troubleshooting Evaluation Errors](#troubleshooting-evaluation-errors)
- [Step 4: Inspect Output](#step-4-inspect-output)
- [Conclusion](#conclusion)
- [Appendix](#appendix)
  - [Setup without Docker](#setup-without-docker)

## Introduction

These instructions
  will step you through the process of
  building and running the evaluation
  using Docker.
This is suitable for those simply aiming
  to reproduce results
  (i.e., artifact evaluators).
For those aiming to do development,
  you should instead follow the instructions in
  [Setup without Docker.](#setup-without-docker)

Steps summary:

0. Kick the tires (less than 1hr)
1. Install proprietary hardware tools (~3hrs)
2. Build Docker image (less than 1hr)
3. Run evaluation inside of Docker container (2-20+hrs, depending on number of cores)
4. Inspect output (~15 minutes)

Important things to note before we begin:

- **Docker is required for building and running the evaluation.**
- **Access to the [lakeroad-private](https://github.com/uwsampl/lakeroad-private)
    repository
    is required for this evaluation.**
  If you are using the Zenodo link in the paper,
    the lakeroad-private files are included.
  If you would like to clone directly from this repo,
    contact the authors (we suggest opening an issue)
    to get access to lakeroad-private.
- **This evaluation must be run on an x86 Linux
    (ideally Ubuntu) machine
    with 300GB of free space.**
  Parts of the evaluation will work on Mac
    (namely, the Lakeroad components),
    but you will not be able to run (let alone install)
    the baseline hardware compilers (Vivado, Quartus, and Diamond).
  We recommend Ubuntu, as that is what we use.
  Windows is completely untested and not recommended.
  The large disk space requirement is mostly due
    to the large size of the proprietary hardware tools.
- **This evaluation benefits from many cores.**
  Our evaluation machine has 128 cores, and takes about 3.5 hours
    while fully using the machine.
- This README is meant to be
    a readable version of the necessary environment setup
    for the evaluation, but
    **in case of bugs or missing information, consult the [Dockerfile](./Dockerfile)
    and the [workflow file](.github/workflows/run-evaluation-leviathan.yml) as ground truth.**
  The Dockerfile is the ground truth
    detailing
    which dependencies
    must be installed
    and which environment variables must be set.
  The workflow file is the ground truth
    detailing how to build the Docker image
    and execute the evaluation within a Docker container.

## Step 0: Kick the Tires

To "kick the tires" of our evaluation,
  you can build our Docker image
  and run the portion of the evaluation
  that does not depend on
  proprietary hardware tools.

First, download the zip archive
  of the evaluation off of Zenodo
  using the link in the paper.
Then, run the following:

```sh
unzip <file-from-zenodo> \
&& cd lakeroad-evaluation \
&& docker build . -t lre-kick-the-tires --build-arg MAKE_JOBS=`nproc` \
&& docker run lre-kick-the-tires doit -n $((`nproc`/4)) '*lakeroad*'
```

If you eventually start seeing output like the following:

```raw
...
.  robustness_experiments:mult_3_stage_unsigned_18_bit:lakeroad_intel:verilator
.  robustness_experiments:muladd_2_stage_signed_8_bit:lattice-ecp5-lakeroad
.  robustness_experiments:mult_2_stage_unsigned_18_bit:lakeroad-xilinx:verilator
.  robustness_experiments:muladd_3_stage_signed_8_bit:lakeroad-xilinx
.  robustness_experiments:muladd_3_stage_signed_8_bit:lattice-ecp5-lakeroad
.  robustness_experiments:muladd_0_stage_unsigned_8_bit:lakeroad-xilinx
.  robustness_experiments:mult_3_stage_unsigned_12_bit:lakeroad-xilinx:verilator
.  robustness_experiments:muladd_0_stage_unsigned_8_bit:lattice-ecp5-lakeroad
.  robustness_experiments:muladd_0_stage_signed_8_bit:lakeroad-xilinx:verilator
.  robustness_experiments:mult_1_stage_unsigned_18_bit:lattice-ecp5-lakeroad:verilator
.  robustness_experiments:muladd_1_stage_unsigned_8_bit:lakeroad-xilinx
.  robustness_experiments:muladd_1_stage_unsigned_8_bit:lattice-ecp5-lakeroad
.  robustness_experiments:muladd_2_stage_unsigned_8_bit:lakeroad-xilinx
...
```

  then the Lakeroad portion of the evaluation
  is successfully running,
  and you should consider the tires kicked.
The evaluation
  won't produce much useful output
  (i.e. figures and tables)
  until the proprietary tools are installed,
  so at this point you should kill the run
  and move on to step 1.

## Step 1: Install Proprietary Hardware Tools

Our [Dockerfile](./Dockerfile)
  automatically builds
  *almost* all of the evaluation's dependencies.
However, a few critical pieces of software are left out:
  the proprietary hardware compiler toolchains Vivado, Quartus, and Diamond.
Why did we leave these out? A few reasons, but chief among them:
  they are very large,
  unwieldy to install,
  and may require generating individual (free) licenses,
  all of which makes packaging inside a Docker image very difficult.

Thus, to fully run the evaluation via Docker,
  you must first install the proprietary hardware compiler toolchains.
Follow the linked instructions,
  and then proceed to step 2.

**Note:** hardware design tools
  are notoriously finicky and difficult.
Please do not blame us for failures
  which occur in this portion
  of evaluation setup.
We will give support
  for installing these tools
  (via HotCRP for artifact evaluators
  or via issues on GitHub),
  but these tools are not ours,
  and thus, there is only so much we can do.
  
### Xilinx Vivado

The evaluation uses Vivado version 2023.1.

To install Vivado,
  please visit
  [this link](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/2023-1.html).
Download the product
  labeled
  "Vivado ML Edition - 2023.1  Full Product Installation"
  via whichever method you prefer.
You will be required to create an account
  on their website
  to download.
From there, running the installer
  should be fairly seamless.
We installed Vivado to `/tools/Xilinx`,
  but you can install it wherever you want.

<!--
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
  -->

### Lattice Diamond

The evaluation uses Lattice Diamond version 3.12.

Unfortunately, Lattice's Diamond toolchain
  is more difficult to install.
We lean on [this blog post](https://community.element14.com/technologies/fpga-group/b/blog/posts/getting-started-with-the-tinyfpga-lattice-diamond-3-12-on-ubuntu-18-04)
  for installing Lattice Diamond.
Please follow all of the instructions
  under the first section
  titled "Install Lattice Diamond".
You can ignore the other sections
  of the post.
(In case the above post disappears,
  the archived version
  is [here](https://web.archive.org/web/20230203012029/https://community.element14.com/technologies/fpga-group/b/blog/posts/getting-started-with-the-tinyfpga-lattice-diamond-3-12-on-ubuntu-18-04).)
These instructions should completely cover
  all of the difficulties
  in installing Diamond.
We ran into many issues following these instructions,
  though in the end,
  they were all errors on our side.
If you similarly run into issues,
  you can
  read the notes we took
  while installing Diamond
  on our own machine:
<https://github.com/uwsampl/lakeroad-evaluation/issues/86>

<!--
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
  -->
  
### Intel Quartus

The evaluation uses Quartus Prime Lite 22.1.

Download and install the software using the instructions
  on [this page](https://www.intel.com/content/www/us/en/software-kit/795187/intel-quartus-prime-lite-edition-design-software-version-23-1-for-linux.html).
We used the "Multiple Download" option
  to download and extract a tarfile.
The new "Installer" method
  may work better,
  but we haven't tested it.
We installed Quartus to `/tools/intel`,
  but you can install it
  wherever you want.
We encountered some issues with Quartus installation,
  documented [here](https://github.com/uwsampl/lakeroad-evaluation/issues/87).
The only change we needed in the end
  was to change the permissions
  of the installed files:

```sh
sudo chmod -R u+rwX,go+rX,go-w /path/to/quartus/install
```

Note that this command may not be needed
  if you use the new "Installer"
  method.

<!--
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
-->

## Step 2: Build Docker Image

Once you have the proprietary hardware tools installed,
  you are now ready to build the Docker image.

If you have downloaded
  the evaluation
  using the Zenodo link,
  unpack it:

```sh
unzip <file-from-zenodo>
cd lakeroad-evaluation
```

Alternatively, if you have access
  to [lakeroad-private](https://github.com/uwsampl/lakeroad-private),
  you can clone this repository directly:

```sh
git clone <url-of-this-repo>
git submodule init; git submodule update
cd lakeroad
git submodule init; git submodule update lakeroad-private
cd ..
```

Next, we will run `docker build`,
  which will roughly look like:

```sh
docker build . -t lakeroad-evaluation \
  --build-arg VIVADO_BIN_DIR=/path/to/Vivado/2023.1/bin \
  --build-arg QUARTUS_BIN_DIR=/path/to/quartus/bin \
  --build-arg DIAMOND_BINDIR=/path/to/diamond/3.12/bin/lin64
  --build-arg MAKE_JOBS=`nproc`
```

We will now describe
  how to set each `--build-arg`
  flag.

`VIVADO_BIN_DIR`,`QUARTUS_BIN_DIR`,and `DIAMOND_BINDIR`
  should be set to the `bin/` (or `bin/lin64/`, for Diamond)
  directories
  for each installed tool.
(Note: these paths will actually
  refer to paths *inside* the Docker image,
  but it's strongly encouraged to just use the same paths that exist on your host system.)

For example, in our [workflow file](.github/workflows/run-evaluation-leviathan.yml), we use the following settings for these arguments:

```sh
  ...
  --build-arg VIVADO_BIN_DIR=/tools/Xilinx/Vivado/2023.1/bin \
  --build-arg QUARTUS_BIN_DIR=/tools/intel/quartus/bin \
  --build-arg DIAMOND_BINDIR=/usr/local/diamond/3.12/bin/lin64 \
  ...
```

Please determine what the appropriate
  settings should be
  on your machine.

`MAKE_JOBS` should be set to the number of parallel jobs
  `make` should use
  when building.
It is generally a safe default
  to set this to the number of processors
  on your machine,
  which can be printed by running `nproc`.

Putting it all together,
  your final command might look
  something like this,
  a simplified form of the command used
  by [our GitHub workflow](https://github.com/uwsampl/lakeroad-evaluation/blob/1ce2fb745db112ca97114cceddc045bfe25a8376/.github/workflows/run-evaluation-leviathan.yml#L58-L65):

```sh
docker build . -t lakeroad-evaluation \
  --build-arg VIVADO_BIN_DIR=/tools/Xilinx/Vivado/2023.1/bin \
  --build-arg QUARTUS_BIN_DIR=/tools/intel/quartus/bin/ \
  --build-arg DIAMOND_BINDIR=/usr/local/diamond/3.12/bin/lin64 \
  --build-arg MAKE_JOBS=`nproc`
```

## Step 3: Run Evaluation

Finally, we will run the evaluation
  inside a Docker container.

Evaluation will take multiple hours.
We suggest running within `tmux` or `screen`.

The entire process is summarized in the following code block.
We will go into further detail about each part.

```sh
# Start a tmux or screen session.
tmux # or `screen`

# Start the Docker container in the background.
docker run \
  -dt \
  --name <container-name> \
  -v /tools/Xilinx:/tools/Xilinx \
  -v /usr/local/diamond:/usr/local/diamond \
  -v /tools/intel:/tools/intel \
  lakeroad-evaluation

# Enter the container.
docker exec -it <container-name> bash

# Execute the evaluation.
export NUM_JOBS_VIVADO_TASKS=...
export NUM_JOBS_LAKEROAD_TASKS=...
export NUM_JOBS_OTHER_TASKS=...
bash /root/run-evaluation.sh
```

We will now explain
  each step.

```sh
tmux # or `screen`
```

This command enters a `tmux` or `screen` session,
  which opens up a persistent terminal
  which you can reconnect to
  even after logging off and logging back onto your machine.
Entering a `tmux` or `screen` session is optional,
  but is helpful for keeping the evaluation running
  for a long period of time.
Search for "tmux cheat sheet" or "screen cheat sheet"
  for the basic commands.

```sh
docker run \
  -dt \
  --name <container-name> \
  -v /tools/Xilinx:/tools/Xilinx \
  -v /usr/local/diamond:/usr/local/diamond \
  -v /tools/intel:/tools/intel \
  lakeroad-evaluation
```

This command starts a Docker container
  in the background.
After this command,
  the Docker container
  (which is similar to a virtual machine)
  will be present
  on the machine, but will not yet be connected to it.

To start the Docker container, we must provide a few flags.

- `-dt` ensures the container is started in the background.
- `--name` can be set to a name of your choosing.
  This will become the name of your container,
    which we will later use
    to copy out the resulting evaluation files.
  For example, `--name lakeroad-evaluation-container`.
- The `-v` flags
    ensure
    that the evaluation
    has access to
    your local installations
    of the proprietary hardware tools
    by mounting the tools inside of the container.
  The flags should look like:

  ```sh
    ...
    -v /path/to/Xilinx:/path/to/Xilinx \
    -v /path/to/diamond:/path/to/diamond \
    -v /path/to/intel:/path/to/intel \
    ...
  ```
  
  We recommend mounting the tools within the containers such that they have the **same
    path as in the host system;** hence, this is why the source path (before the colon)
    is the same as the destination path (after the colon).
  For example, in our [workflow file](.github/workflows/run-evaluation-leviathan.yml), we use the following settings for these arguments:

  ```sh
    ...
    -v /tools/Xilinx:/tools/Xilinx \
    -v /usr/local/diamond:/usr/local/diamond \
    -v /tools/intel:/tools/intel \
    ...
  ```

  Again, these paths will be different depending on where you installed these tools in step 1. **Note that we mount the entire tool folder and not just the `bin` folder;** e.g. we mount `/tools/Xilinx` instead of `/tools/Xilinx/Vivado/2023.1/bin`.

```sh
docker exec -it <container-name> bash
```

This command enters the Docker container.
Use the container name you chose above.
After this command, you should see your
  terminal prompt change.
If you run `ls`, you will see
  that you are now in a different directory.

```sh
export NUM_JOBS_VIVADO_TASKS=<num-jobs-vivado-tasks>
export NUM_JOBS_LAKEROAD_TASKS=<num-jobs-lakeroad-tasks>
export NUM_JOBS_OTHER_TASKS=<num-jobs-other-tasks>
export PRINT_UPTIME_INTERVAL=60
bash /root/run-evaluation.sh
```

These commands run the evaluation.
The environment variables
  `NUM_JOBS_VIVADO_TASKS`,
  `NUM_JOBS_LAKEROAD_TASKS`, and
  `NUM_JOBS_OTHER_TASKS`
  determine
  the number of parallel tasks
  that are used
  for each
  portion
  of the evaluation.
Correctly setting these
  can reduce the evaluation runtime
  by hours!
However, tuning
  these numbers to be correct
  can be quite annoying.
Thus, we provide two methods
  for setting these variables:
  an easy but potentially non-performant method,
  and a more involved but more performant method.

**Easy but potentially non-performant.**
A quick-and-dirty setting
  of these variables
  that should work on most machines
  would be the following:

```sh
export NUM_JOBS_VIVADO_TASKS=$((`nproc`/3))
export NUM_JOBS_LAKEROAD_TASKS=$((`nproc`/6))
export NUM_JOBS_OTHER_TASKS=$((`nproc`/2))
```

**More involved but more performant.**
A more involved method of determining
  appropriate settings
  for these variables
  involves tuning the numbers
  based on the `uptime` readings
  that are printed during evaluation.
`run-evaluation.sh` will print the result of
  `uptime`
  at an interval determined by the setting of
  `PRINT_UPTIME_INTERVAL` (in seconds).
In our above set of commands,
  we use a 60 second interval.
To tune the number of parallel tasks,
  you can attempt to raise the load average
  to somewhere between 80-100%
  by increasing the number of parallel tasks.
The `run-evaluation.sh` script prints information
  about which group of tasks
  are being run
  (Vivado tasks, then Lakeroad tasks, then remaining tasks).
If your number of parallel tasks is too high,
  this will manifest in one or both of these ways:
  (1) for non-Vivado tasks, your load average will be above 100,
    and the tasks will run very slowly as a result
    due to thrashing;
  (2) for the Vivado tasks, you will see Vivado crashing
    (likely due to out of memory errors).
On our 64-core, 128-thread machine,
  we use 50 parallel Vivado tasks,
  20 parallel Lakeroad tasks,
  and 100 parallel tasks for the remaining tasks.

Note that
  our evaluation framework
  caches successfully run experiments,
  so you can kill the evaluation
  and restart it
  without worrying about losing progress.
Similarly, you can disconnect
  from and reconnect to your
  Docker container
  without worrying about losing progress.

### Troubleshooting Evaluation Errors

This subsection documents errors
  you may encounter
  while running the evaluation,
  and how to troubleshoot them.

**Vivado failures.**
Unfortunately, Vivado is *very* finicky
  and is likely to crash
  on at least a few experiments.
Please remember
  that Vivado is not our tool,
  and in fact,
  that frustrations with Vivado
  are part of what inspired the creation of Lakeroad.
To debug Vivado failures,
  we recommend one of two steps:
(1) Simply rerun the evaluation script.
Vivado's errors are often unpredictable,
  and will go away on a second try.
(2) Lower the number of parallel
  tasks used when running the Vivado
  tasks.
See the section above for details.
If neither of these options work,
  please open an issue here
  (or leave a comment on HotCRP,
    for artifact evaluators).

## Step 4: Inspect Output

Finally, we will inspect the output
  of the evaluation.

To do so, we will first copy the output folder
  out of the container
  and onto the host machine:

```sh
docker container cp <container-name>:/root/out out/
```

This command copies the folder at
  `/root/out` (the default location for evaluation outputs)
  to `out/`.
Use the same container name
  from step 3.

Now you can inspect
  the outputs
  and compare them to the figures and tables
  in the paper.
The following is a list of the important outputs
  to inspect
  inside of `out/`.

- `figures/lakeroad_is_x_times_better.csv`:
  This file captures data on the multiplicative factor
    by which Lakeroad outperforms other tools
    with regard to completeness.
  These numbers appear in the
    text: specifically,
    in the abstract,
    at the end of the introduction,
    and in the evaluation
    (5.1, Comparison to Existing Toolchains, first paragraph).
- `figures/lakeroad_time_{intel,lattice,xilinx}.png`:
  These are the images used in Figure 7.
- `figures/resource_percentages.csv`:
  The numbers for Lakeroad's mean resource reduction.
  These numbers appear
    in the evaluation
    (5.1, Comparison to Existing Toolchains, final paragraph).
- `figures/solver_counts.csv`:
  The number of experiments solved by each solver.
  These numbers appear
    in the evaluation
    (5.1, Comparison to Existing Toolchains,
    second to last paragraph).
- `figures/succeeded_vs_failed_all.png`:
  This is the image used in Figure 6.
- `figures/timing_table.csv`:
  This is the data from which the table in Figure 6 is generated.
- `line_counts/architecture_descriptions.csv`:
  The number of source lines of code (SLoC)
    for the architecture descriptions in Lakeroad.

## Conclusion

At this point,
  you should have succeeded
  in installing all prerequisite software,
  building the Docker image,
  running the evaluation,
  and inspecting the results.
If you run into issues during this process,
  please open an issue on the repository
  (or, for our artifact evaluators,
    add a comment on HotCRP).

## Appendix

### Setup without Docker

If you are interested in setting up
  the evaluation
  to run outside of Docker,
  e.g. so that you can develop on it,
  follow these instructions.

For now, I will simply refer you to the Dockerfile,
  which documents how your local environment should be set up.

TODO(@gussmith23).

<!-- 
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
-->
