# Data-analysis scripts that for tables and plots

## tables.R
```
Rscript tables.R <gathered_data folder> <output folder> <identifier-map.csv>
```

This script consolidates all data files in `gathered_data` and produces LaTex
tables for the paper.

The provided identifier-map.csv serves two purposes:
1. Limit the number of designs shown in the final table (designs not listed are
   filtered).
2. Provide a human-readable name for each design.

After execution, the output folder contains:
* `resource-body.tex`: The table body for the resource-utilization table.
