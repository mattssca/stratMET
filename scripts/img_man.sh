#!/bin/bash

#combine png for report format
convert -quiet out/*_plot_title.png out/*_filtered_metrics_tab.png out/*_box2.png out/*_discrepancies_genome_strat.png out/*_box2.png -append -quiet out/report.png

#clean folder
rm out/*_plot_title.png
rm out/*_box2.png
rm out/*_discrepancies_genome_strat.png
rm out/*_filtered_metrics_tab.png
rm Rplots.pdf