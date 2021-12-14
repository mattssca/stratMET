# stratMET
R Package for processing csv files with variant metrics for different genomic stratifications. Package also compares candidate variant benchmark to additional variant call-sets, highlighting discrepancies between call-sets in a genome-stratification-aware manner.

## Instructions on How to Execute
1. Download repo to local machine with: `wget https://github.com/mattssca/stratMET/archive/refs/heads/main.zip`
2. Unpack with: `unzip -a main.zip`
3. Set directory as current directory: `cd stratMET-main/`
4. Install dependencies: `sh install.dep.sh`
5. Migrate input csv files to `/in` folder. (to run pipeline with example data, enter `mv example-data.csv in/`)
6. Execute master script with: `sh stratMET.sh` 
7. Output files are generated and saved to `/out` folder.

## Flowchart
(coming soon...)

## Scripts
1. [stratMET.R](https://github.com/mattssca/stratMET/blob/main/scripts/stratMET.R]), Main R script that performs necessary data wrangling-tasks and computes relevant variant call-set metrics. 
2. [bench_comp.R](https://github.com/mattssca/stratMET/blob/main/scripts/bench_comp.R]), R script that merges additional variant call-sets (.csv) with candidate benchmark call-set to highlight region-specific discrepancies.
3. [img_man.sh](https://github.com/mattssca/stratMET/blob/main/scripts/img_man.sh), are called to compile individual plots into a report format in pdf.
4. [install_dep.R](https://github.com/mattssca/stratMET/blob/main/scripts/install_dep.R]), Script for installing necessary R packages.
5. [instal.dep.sh](https://github.com/mattssca/stratMET/blob/main/install.dep.sh]), Shell script for installing all necessary dependencies (calls above mentioned R script).
6. [stratMET.sh](https://github.com/mattssca/stratMET/blob/main/stratMET.sh]), Main script for executing the workflow.

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
