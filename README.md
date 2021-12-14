# stratMET
R Package for processing csv files with variant metrics for different genomic stratifications. Package also compares candidate variant benchmark to additional variant call-sets, highlighting discrepancies between call-sets in a genome-stratification-aware manner.

## Instructions on How to Execute
1. Download repo to local machine with: `wget https://github.com/mattssca/stratMET/archive/refs/heads/main.zip`
2. Unpack with: `unzip -a main.zip`
3. Set directory as current directory: `cd stratMET-main/`
4. Install dependencies: `sh install_dep.sh`
5. Migrate input csv files to `/in` folder.
6. Execute master script with: `sh stratMET.sh` 
7. Output files are generated and saved to `/out` folder.

## Flowchart

## Scripts

## Example Output
### Tables and .xlxs
Pipeline outputs table (Table 1.) showing filtered variant-metrics for a selected number of genome stratifications. Total number of variants (all stratifications), total number of indels and SNPs are printed in table header. Fraction of discordant variants by selected genome stratification is computed as follows:

![equation](https://github.com/mattssca/stratMET/blob/main/example-outs/equation.png)

Example output for above described table (Hifiasm-v0.11-dipcall0.3-vs-4.2.1_HG002_GRCh38_v4.2.1.extended.csv):

![example_table](https://github.com/mattssca/stratMET/blob/main/example-outs/example-table.png)

### Discrepancy by genome stratification plot 
Stacked barplot with number of discrepancies ranked by genome stratification:

![example_plot](https://github.com/mattssca/stratMET/blob/main/example-outs/example-figure.png)

## Dependencies
Pipeline is designed to work on MacOSX systems. Disclaimer, pipeline has not been tested on either Windows or Linux systems.
In order to install all dependencies, execute [install.dep.sh](https://github.com/mattssca/stratMET/blob/main/install_dep.sh)

| Package | Enviroment | Version |
| ------- | ---------- | ------- |
| Brew | MacOSX | 3.2.0 |
| wget | MacOSX | 1.21.2 |
| imagemagick | C | 7.1.0 |
| dplyr | R | 2.1.1 |
| gridExtra | R | 2.3 |
| ggthemr | R | 1.1.0 |
| openxlsx | R | 4.2.4 |
| tidyr | R | 1.1.3 |
| ggplot2 | R | 3.3.5 |
| devtools | R	| 2.4.2 |
