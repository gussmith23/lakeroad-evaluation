#
# Export plots.
#
# Usage: Rscript plots.R <gathered_data folder> <output folder> <identifier-map.csv> <resource-map.csv>
#
# Example: Rscript plots.R results/gathered_data /tmp ./identifier-map.csv ./resource-map.csv
#
# The output folder must exist.
suppressPackageStartupMessages({
  library(reshape2)
  library(tidyverse)
})

################################################################################
# Check arguments
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 4) {
  stop("Usage: Rscript tables.R <gathered_data folder> <output folder> <identifier-map.csv> <resource-map.csv>")
}
for (dir in args[1:2]) {
  if (! dir.exists(dir)) {
    stop(paste0("Directory does not exist: ", dir))
  }
}
if (! file.exists(args[3])) {
  stop(paste0("identifier mapping does not exist: ", args[3]))
}
if (! file.exists(args[4])) {
  stop(paste0("resource mapping does not exist: ", args[4]))
}

################################################################################

################################################################################
# Input/output folders and identifier map
DIR_RESULTS      <- args[1]
DIR_OUTPUT       <- args[2]
CSV_IDENT_MAP    <- args[3]
CSV_RESOURCE_MAP <- args[4]

# List (and order) of columns that correspond to resources for various tools
# Lakeroad
LR_RES_COLS <- c("LUT2", "LUT4", "LUT6", "CCU2C", "CARRY8", "DSP48E2", "frac_lut4")
# Yosys
YOSYS_RES_COLS <- c("LUT4", "L6MUX21", "PFUMX", "CCU2C", "MULT18X18D")
# Diamond
DIAMOND_RES_COLS <- c("num_LUT4", "num_CCU2C", "num_PFUMX", "num_ALU54B", "num_MULT18X18D", "num_L6MUX21", "num_MULT9X9D")
# Vivado
VIVADO_RES_COLS <- c("clb_luts", "clb_regs", "carry8s", "f7muxes", "f8muxes", "f9muxes")

# List (and order) of all resource columns
RES_COLS <- c(LR_RES_COLS, YOSYS_RES_COLS, DIAMOND_RES_COLS, VIVADO_RES_COLS)

# Identifier column (design name) over which to join the results
IDENT_COL <- "identifier"

# Identifier column name for Lakeroad results
LR_IDENT_COL <- "module_name"
################################################################################

main <- function() {
  plot_resources("resources-plot.pdf")
}

#
# Export table for resource utilization for all architectures and tools.
#
plot_resources <- function(filename) {
  # Consolidate all results files into a single data frame
  df <- consolidate()

  # Create a stacked bar chart, sliced by tool and architecture
  p <- ggplot(df) + geom_bar(stat="identity", aes(x=resource_value, y=name, fill=resource_name)) +
        facet_grid(architecture~tool) + theme_bw() +
        xlab("Number of resources") + ylab("Design") +
        theme(legend.position="top", legend.key.size = unit(6, "pt")) +
        scale_y_discrete(limits=rev) +
        guides(fill=guide_legend(title="Resources"))

  # Write plot to pdf
  cairo_pdf(paste0(DIR_OUTPUT, "/", filename), width=10, height=8)
    print(p)
  dev.off()
}

#
# Create a single, consolidated data frame (long format) from the raw data.
#
consolidate <- function() {
  # Read a results csv and drop the first column (which holds the row names)
  read <- function(filename) {return(read.csv(filename)[, -1])}

  old_wd <- getwd()
  setwd(DIR_RESULTS)
  lr_lattice      <- sanitize_df(read("lakeroad_lattice_ecp5_diamond_results.csv"), "lakeroad", "lattice")
  yosys_lattice   <- sanitize_df(read("yosys_lattice_ecp5_baseline.csv"), "yosys", "lattice")
  diamond_lattice <- sanitize_df(read("diamond_baseline.csv"), "diamond", "lattice")

  lr_xilinx       <- sanitize_df(read("lakeroad_xilinx_ultrascale_plus_vivado_results.csv"), "lakeroad", "xilinx")
  yosys_xilinx    <- sanitize_df(read("yosys_xilinx_ultrascale_plus_baseline.csv"), "yosys", "xilinx")
  vivado_xilinx   <- sanitize_df(read("vivado_baseline.csv"), "vivado", "xilinx")

  lr_sofa         <- sanitize_df(read("lakeroad_sofa_results.csv"), "lakeroad", "sofa")
  setwd(old_wd)

  # Map identifiers to human-readable names and limit the set of identifiers
  # that will eventually end up in the output table.
  ident_map  <- read.csv(CSV_IDENT_MAP)
  # Map resource identifiers to canonical names
  res_map    <- read.csv(CSV_RESOURCE_MAP)

  df <- bind_rows(list(lr_lattice, yosys_lattice, diamond_lattice, lr_xilinx, yosys_xilinx, vivado_xilinx, lr_sofa)) %>%
    inner_join(ident_map) %>%
    inner_join(res_map) %>%
    # Replace all NAs (resource counts) with 0
    replace(is.na(.), 0)

  return(df)
}

#
# Sanitize a data frame that holds results for a given tool and architecture.
#
sanitize_df <- function(df, tool, arch) {
  clean_df <- df
  # Lakeroad results have a "module_name" column; baseline results have "identifier"
  if (LR_IDENT_COL %in% colnames(df)) {
    # Extract the identifier from the module name
    clean_df <- clean_df %>%
      mutate(identifier = str_replace(module_name, "^.*_([^_]+_[0-9])", "\\1")) %>%
      group_by(identifier) %>%
      # For now we pick the first entry for duplicated identifiers. Duplicates
      # are caused by synthesizing the same design with different templates.
      # TODO: Figure out which templates to keep, or whether to report on
      #       different variants of Lakeroad.
      slice(1)
  }

  # Retain only columns of interest: identifier and resource columns
  clean_df <- select(clean_df, identifier, any_of(RES_COLS))

  clean_df.m <- melt(clean_df, id.vars=c("identifier"), variable.name="resource_identifier", value.name="resource_value")
  clean_df.m$tool <- tool
  clean_df.m$architecture <- arch

  return(clean_df.m)
}

main()
