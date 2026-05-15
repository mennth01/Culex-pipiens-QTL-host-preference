#Set working directory and load libraries
setwd("C:/Users/Theresa Menna/Documents/Fritz Lab/QTL/gemma_results")
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)

# Load heterozygosity for all samples
het <- read.table("All.het", header = TRUE)

# Load filename lists to filter by
E.parents <- readLines("Evanston-F0s.txt")
C.parents <- readLines("Cal1-F0s.txt")
offspring <- readLines("filtered_sorted_bams_F2only.txt")

BCs <- offspring[grep("BcEV", offspring)]
F2s <- offspring[grep("F1", offspring)]

# Filter samples in the heterozyogosity table
het <- het %>%
  mutate(GROUP = case_when(
    INDV %in% E.parents ~ "AG2_Parents",
    INDV %in% C.parents ~ "BG1_Parents",
    INDV %in% BCs ~ "BCs", 
    INDV %in% F2s ~ "F2s"
    )) %>% 
  na.omit()

# Plot
p <- ggplot(het, aes(x = GROUP, y = F)) +
  geom_jitter(width = 0.2, size = 2, alpha = 0.7) +
  labs(x = "", y = "Homozygosity (F) per individual") +
  theme_minimal() #+
  #ylim(0,1)


het_summary <- het %>%
  group_by(GROUP) %>%
  summarise(
    mean_F = mean(F, na.rm = TRUE),
    sd_F = sd(F, na.rm = TRUE)
  )

# View the summary table
print(het_summary)

my_colors <- c(
  "BG1_Parents" = "#E57373",      # Muted red
  "AG2_Parents" = "#64B5F6",  # Blue
  "F2s" = "#BA68C8",        # Lighter purple
  "BCs" = "#7E57C2"       # Deeper purple
)

desired_order <- c("BG1_Parents", "F2s", "BCs", "AG2_Parents")

het$GROUP <- factor(het$GROUP, levels = desired_order)


p <- ggplot(het, aes(x = GROUP, y = F)) +
  geom_jitter(aes(color = GROUP), width = 0.2, size = 2, alpha = 0.7) + 
  scale_color_manual(values = my_colors) +
  geom_errorbar(data = het_summary, 
                aes(y = mean_F, ymin = mean_F - sd_F, ymax = mean_F + sd_F), 
                color = "black", width = 0.1) +
  geom_crossbar(data = het_summary, aes(y = mean_F, ymin = mean_F, ymax = mean_F), 
             color = "black", linewidth = 0.3, width = 0.3) +
  labs(x = "", y = "Homozygosity (F) per individual") +
#  ylim(-0.75,0.75) + 
  theme_minimal() + 
  theme(legend.position = "none", text=element_text(size=14), axis.text.x = element_text(color = "black", face = "bold"))

print(p)

#--------------------------------------
#Change point shape so that we can see switchers versus others on the plot
#--------------------------------------

het <- het %>%
  mutate(PHEN = case_when(
    # Check for 3 hyphens AND the C-based patterns
    str_count(INDV, "-") == 3 & str_detect(INDV, "CCC|CCN|CNC|NCC") ~ "avian",
    
    # Check for 3 hyphens AND the H-based patterns
    str_count(INDV, "-") == 3 & str_detect(INDV, "HHH|HHN|HNH|NHH") ~ "human",
    
    # Check for any other samples that have exactly 3 hyphens
    str_count(INDV, "-") == 3 ~ "switcher",
    
    # Everything else
    TRUE ~ "N/A (parents)"
  ))

p <- ggplot(het, aes(x = GROUP, y = F)) +
  geom_jitter(aes(color = GROUP, shape = PHEN), width = 0.2, size = 2, alpha = 0.7) + 
  scale_shape_manual(values = c(
    "avian" = 16, 
    "human" = 17, 
    "switcher" = 4, 
    "N/A (parents)" = 15
  )) +
  scale_color_manual(values = my_colors) +
  geom_errorbar(data = het_summary, 
                aes(y = mean_F, ymin = mean_F - sd_F, ymax = mean_F + sd_F), 
                color = "black", width = 0.1) +
  geom_crossbar(data = het_summary, aes(y = mean_F, ymin = mean_F, ymax = mean_F), 
                color = "black", linewidth = 0.3, width = 0.3) +
  labs(x = "", y = "Homozygosity (F) per individual", shape = "Phenotype") +
  theme_minimal() + 
  theme(
    legend.position = "right", # Change "none" to "right", "left", "top", or "bottom"
    text = element_text(size = 14), 
    axis.text.x = element_text(color = "black", face = "bold")
  ) +
  # This line hides the color legend specifically while keeping the shape legend
  guides(color = "none")

print(p)

#ggsave("homozygosity_plot.png", plot=p, dpi = 500)
