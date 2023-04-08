#
# Export tables in LaTex format.
#
# Usage: Rscript tables.R <gathered_data folder> <output folder> <identifier-map.csv>
#
# Example: Rscript tables.R results/gathered_data /tmp ./identifier-map.csv
#
# The output folder must exist.
suppressPackageStartupMessages({
  library(tidyverse)
  library(xtable)
})

################################################################################
# Check arguments
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3) {
  stop("Usage: Rscript tables.R <gathered_data folder> <output folder> <identifier-map.csv>")
}
for (dir in args[1:2]) {
  if (! dir.exists(dir)) {
    stop(paste0("Directory does not exist: ", dir))
  }
}
if (! file.exists(args[3])) {
  stop(paste0("identifier mapping does not exist: ", args[3]))
}
################################################################################

################################################################################
# Input/output folders and identifier map
DIR_RESULTS   <- args[1]
DIR_OUTPUT    <- args[2]
CSV_IDENT_MAP <- args[3]

# List (and order) of columns that correspond to resources for various tools
# Lakeroad
LR_RES_COLS <- c("LUT2", "LUT4", "LUT6", "CCU2C", "CARRY8", "DSP48E2")
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
  export_resources("resources-body.tex")
  # TODO: Runtime results, other comparisons?
  #export_runtimes("runtimes-body.tex")
}

#
# Export table for resource utilization for all architectures and tools.
#
export_resources <- function(filename) {
  # Consolidate all results files into a single data frame
  df <- consolidate()
  # Sort data by identifier and output LaTex table
  latex_table(arrange(df, identifier), filename, NA_string="\\zero", fun_sanitize=NULL)
}

#
# Create a single, consolidated data frame from the raw data.
#
consolidate <- function() {
  # Read a results csv and drop the first column (which holds the row names)
  read <- function(filename) {return(read.csv(filename)[, -1])}

  old_wd <- getwd()
  setwd(DIR_RESULTS)
  lr_lattice      <- sanitize_df(read("lakeroad_lattice_ecp5_diamond_results.csv"), "lr_lattice")
  yosys_lattice   <- sanitize_df(read("yosys_lattice_ecp5_baseline.csv"), "yosis_lattice")
  diamond_lattice <- sanitize_df(read("diamond_baseline.csv"), "diamond_lattice")

  lr_xilinx       <- sanitize_df(read("lakeroad_xilinx_ultrascale_plus_vivado_results.csv"), "lr_xilinx")
  yosys_xilinx    <- sanitize_df(read("yosys_xilinx_ultrascale_plus_baseline.csv"), "yosys_xilinx")
  vivado_xilinx   <- sanitize_df(read("vivado_baseline.csv"), "vivado_xilinx")

  #TODO: Add Sofa?
  setwd(old_wd)

  # Map identifiers to human-readable names and limit the set of identifiers
  # that will eventually end up in the output table.
  ident_map      <- read.csv("identifier-map.csv") 

  df <- lr_lattice %>%
    full_join(yosys_lattice) %>%
    full_join(diamond_lattice) %>%
    full_join(lr_xilinx) %>%
    full_join(yosys_xilinx) %>%
    full_join(vivado_xilinx) %>%
    # Replace 0s with NA to allow for customization of how these are rendered
    replace(.==0, NA) %>%
    # All counts are integers.
    mutate(across(where(is.numeric), as.integer)) %>%
    # Right join with ident_map to only keep identifiers listed in that file
    # This join also introduces the "name" column, a human-readable label for
    # identifiers.
    right_join(ident_map) %>%
    relocate(name, .after=identifier)

  return(df)
}

#
# Sanitize a data frame that holds results for a given tool and architecture.
#
sanitize_df <- function(df, col_prefix) {
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

  clean_df <- clean_df %>%
    # Retain only columns of interest: identifier and resource columns
    select(identifier, any_of(RES_COLS)) %>%
    # Add a prefix to all non-identifier columns to ease joining data frames
    rename_with(~ paste0(col_prefix, "_", .), any_of(RES_COLS))

  # Make sure the 'identifier' column is unique
  stopifnot(length(clean_df$identifier) == length(unique(clean_df$identifier)))

  return(clean_df)
}

################################################################################
#
# Make all character values a macro (i.e., prefix with "\")
#
text_to_macro <- function(text) { return(paste0("\\", gsub("_.*", "", text))) }

#
# Make all 0s a macro (\zero).
#
zero_to_macro <- function(text) { return(gsub("^0$", "\\zero", text)) }

#
# Print table body in LaTex format: xtable is sufficiently configurable.
# df:            Dataframe to export
# filename:      Filename of the tex file (DIR_OUTPUT is automatically prepended)
# hline_after:   Place a horizontal line after line
#                - default is -1 (no line)
#                - use nrow(df)-1 to put a line before the last row (e.g., before "Total")
# zero_to_macro: Replace all 0s with a LaTex macro (\zero)?
#                - default is FALSE
# fun_sanitize:  Call this function for every character value in the data frame
#                - default is text_to_macro, turning every value into a tex macro
#                - set to NULL to keep each value as is
# digits:        Precision for each column
#                - must be a vector of length num(cols) + 1, where the first
#                  entry corresponds to the row-names column
#
latex_table <- function(df, filename, hline_after=-1, NA_string="", fun_sanitize=text_to_macro, digits=NULL) {
  sink(paste0(DIR_OUTPUT, "/", filename))
    cat("%", paste(colnames(df), collapse=" & "), "\n")
    print(xtable(df, digits=digits), hline.after=hline_after, only.contents=T, booktabs=T,
        format.args=list(big.mark = ",", decimal.mark = "."),
        NA.string=NA_string, sanitize.text.function=fun_sanitize,
        include.rownames=F, include.colnames=F, comment=F)
  sink()
}

main()
