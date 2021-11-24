#!/bin/bash

echo "stratMET is a set of scripts that performes initial data wrangling on input .csv file to filter/subset data and plots relevant performance metrics together with tables.\n"

Rscript scripts/stratMET.R

echo "Processing in R complete...\n"

sh scripts/img_man.sh

echo "Report compiled!\n"