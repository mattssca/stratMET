#R script for processing csv files with variant metrics for different genomic stratifications
#author, Carl-Adam Mattsson. omYXX informatics.

#remove warning messages
options(warn=-1)

#load packages
suppressMessages(library(dplyr))
suppressMessages(library(ggplot2))
suppressMessages(library(gridExtra))
suppressMessages(library(ggthemr))
suppressMessages(library(tidyr))
suppressMessages(library(openxlsx))

#get sample name
strat.list = list.files(path = "in/", recursive = TRUE, pattern = "\\.csv$", full.names = TRUE)
sample_name = gsub(".{4}$", '', strat.list)
sample_name = substring(sample_name, 5)

#set parameters
now = format(Sys.time(), "%d_%m_%Y")
txtFileName <- paste0(sample_name, "_strat_met_", now)

#read vcf into R (skip header)
strat_met = read.table(file = paste0("in/", sample_name, ".csv"), sep = ",", header = T)

#subset data (select variables and rows)
strat_met_sub = strat_met %>% select("Subset", "Subtype", "Type", "Filter", "METRIC.Recall", "METRIC.Precision", "METRIC.Frac_NA", "METRIC.F1_Score", "FP.gt", "FP.al", "TRUTH.FN")

#subset data on specific rows (all benchmark regions, alldifficult, and notinalldifficult)
#all benchmark regions
strat_met_sub_all = filter(strat_met_sub, Subset == "*")
strat_met_sub_all = filter(strat_met_sub_all, Subtype == "*")
strat_met_sub_all = filter(strat_met_sub_all, Filter == "PASS")

#all difficult regions
strat_met_sub_alldif = filter(strat_met_sub, Subset == "alldifficultregions")
strat_met_sub_alldif = filter(strat_met_sub_alldif, Subtype == "*")
strat_met_sub_alldif = filter(strat_met_sub_alldif, Filter == "PASS")

#not in all difficult regions
strat_met_sub_notinalldif = filter(strat_met_sub, Subset == "notinalldifficultregions")
strat_met_sub_notinalldif = filter(strat_met_sub_notinalldif, Subtype == "*")
strat_met_sub_notinalldif = filter(strat_met_sub_notinalldif, Filter == "PASS")

#change Subset description for all benchmark regions
strat_met_sub_all$Subset = as.factor(strat_met_sub_all$Subset)
strat_met_sub_alldif$Subset = as.factor(strat_met_sub_alldif$Subset)
strat_met_sub_notinalldif$Subset = as.factor(strat_met_sub_notinalldif$Subset)
levels(strat_met_sub_all$Subset)[levels(strat_met_sub_all$Subset)=="*"] = "all_benchmark_regions"
levels(strat_met_sub_alldif$Subset)[levels(strat_met_sub_alldif$Subset)=="alldifficultregions"] = "all_difficult_regions"
levels(strat_met_sub_notinalldif$Subset)[levels(strat_met_sub_notinalldif$Subset)=="notinalldifficultregions"] = "not_in_all_difficult_regions"

#rbind all stratifications
strat_metrics_filtered = rbind(strat_met_sub_all, strat_met_sub_alldif, strat_met_sub_notinalldif)

#drop non-informative variables
strat_metrics_filtered = select(strat_metrics_filtered,-c(Subtype, Filter))

#update variable names
names(strat_metrics_filtered)[names(strat_metrics_filtered) == "METRIC.Recall"] = "Recall"
names(strat_metrics_filtered)[names(strat_metrics_filtered) == "METRIC.Precision"] = "Precision"
names(strat_metrics_filtered)[names(strat_metrics_filtered) == "METRIC.Frac_NA"] = "Fraction_NA"
names(strat_metrics_filtered)[names(strat_metrics_filtered) == "METRIC.F1_Score"] = "F1_Score"

#subset data for table export
strat_met_table = strat_metrics_filtered %>% select("Subset", "Type", "Recall", "Precision", "Fraction_NA", "F1_Score", "FP.gt", "FP.al", "TRUTH.FN")
strat_met_table_filt = strat_metrics_filtered %>% select("Subset", "Type", "Recall", "Precision", "Fraction_NA", "F1_Score")

#tables
#set table theme
theme_1 = ttheme_default(core = list(fg_params = list(hjust = 0, x = 0.1, fontsize = 9)), colhead = list(fg_params = list(fontsize = 12, fontface = "bold")))

#convert table to df
strat_met_table = as.data.frame(strat_met_table)

#convert data frame into grob
strat_met_grob = grid.arrange(top = "Table 1. Filtered variant (Indel & SNP) metrics by stratification.", tableGrob(strat_met_table, theme = theme_1, rows = NULL))

##plotting
#set plot theme
ggthemr("fresh")

#subset data for plot and subset on variant type
strat_met_plot = strat_metrics_filtered %>% select("Subset", "Type", "FP.gt", "FP.al", "TRUTH.FN")
strat_met_plot_indel = filter(strat_met_plot, Type == "INDEL")
strat_met_plot_indel = select(strat_met_plot_indel,-c(Type))
strat_met_plot_snp = filter(strat_met_plot, Type == "SNP")
strat_met_plot_snp = select(strat_met_plot_snp,-c(Type))

#melt df to create stacked plots
indel_plot = strat_met_plot_indel %>%
  gather(Type, Value, -Subset)

snp_plot = strat_met_plot_snp %>%
  gather(Type, Value, -Subset)

#create stacked bar-plot, number of discrepancies (FP.gt, FP.al, and TRUTH.FN) ranked by genome stratification.
strat_indels_plot = ggplot(indel_plot, aes(x = Subset, y = Value, fill = Type)) +
  labs(title = "INDEL", subtitle = "Stacked barplot with number of discrepancies ranked by genome stratification",x = "", y = "Number of variants", fill = "") +
  geom_bar(position = "stack", stat = "identity") +
  theme(legend.position = "none", axis.text.x = element_text(angle = 45, hjust = 1), plot.margin=unit(c(1,1,1,1),"cm"))

strat_snp_plot = ggplot(snp_plot, aes(x = Subset, y = Value, fill = Type)) +
  labs(title = "SNP", subtitle = "Stacked barplot with number of discrepancies ranked by genome stratification",x = "", y = "", fill = "") +
  geom_bar(position = "stack", stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.margin=unit(c(1,1,1,1),"cm"))

#plot empty box for spacing
box = ggplot() +
  geom_blank(mapping = NULL, data = NULL, stat = "identity", position = "identity", show.legend = NA, inherit.aes = TRUE) + 
  theme(axis.line.x = element_blank(), axis.line.y = element_blank(), panel.background = element_rect(fill = "white", colour = "white"))

#plot header for raport
text = paste0(sample_name, " | GRCh38 | Performance Metrics | ", now)
plot.title = ggplot() + 
  annotate("text", x = 7, y = 3, size = 5.5, label = text) + 
  theme_void() +
  theme(panel.background = element_rect(fill = "white", colour = "white"))

#put plots side-by-side
plots.grid = grid.arrange(strat_indels_plot, strat_snp_plot, ncol=2)

#write each data frame as a separate sheet to xlsx
list_of_datasets = list("Filtered Metrics" = strat_met_table_filt, "Indels Discrepancies" = strat_met_plot_indel, "SNP Discrepancies" = strat_met_plot_snp)
write.xlsx(list_of_datasets, paste0("out/", txtFileName, "_metrics.xlsx"))

#export tables and plots
ggsave(plots.grid, file = paste0("out/", txtFileName, "_discrepancies_genome_strat.png"), limitsize = FALSE, width = 14, height = 7, units = c("in"), dpi = 300)
ggsave(strat_met_grob, file = paste0("out/", txtFileName, "_filtered_metrics_tab.png"), limitsize = FALSE, width = 14, height = 2, units = c("in"), dpi = 300)
ggsave(box, file = paste0("out/", txtFileName, "_box2.png"), limitsize = FALSE, width = 14, height = 0.3, units = c("in"), dpi = 300)
ggsave(plot.title, file = paste0("out/", txtFileName, "_plot_title.png"), limitsize = FALSE, width = 14, height = 2, units = c("in"), dpi = 300)
   
