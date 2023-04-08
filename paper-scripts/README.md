# Data-analysis scripts that for tables and plots

1. Extract the evaluation-results archive from GH actions and unzip it in this
   folder. This should create: `results/gathered_data`.

2. Run make to generate tables and plots. These are written to `generated`.

## Mapping files

### identifier-map.csv
This file serves two purposes:

1. Limit the number of designs shown in the final table (designs not listed are
   filtered).

2. Provide a human-readable name for each design.

### resource-map.csv
This file maps resource identifiers to canonical names. These canocial names are
both more readable and group related resources across different architectures.

## Individual scripts

### tables.R
```
Rscript tables.R <gathered_data folder> <output folder> <identifier-map.csv>
```

This script consolidates all data files in `gathered_data`, puts them into wide
format, and produces LaTex tables for the paper.

After execution, the output folder contains:

* `resources-body.tex`: The table body for the resource-utilization table.

### plots.R
```
Rscript plots.R <gathered_data folder> <output folder> <identifier-map.csv> <resource-map.csv>
```

This script consolidates all data files in `gathered_data`, puts them into long
format, and plots resource utilization.

After execution, the output folder contains:

* `resources-plots.pdf`: The resource-utilization plot.
