library(dplyr)
library(tidyverse)
library(ggplot2)

setwd("C:/Users/Theresa Menna/Documents/Fritz Lab/QTL/LD_decay/")

LD <- read.table("hostpref_LD_r2.ld", header=TRUE)

# Adjust avgLD with N, CI bounds, and a midpoint for clean plotting
avgLD <- LD %>% 
  mutate(markerDistance = abs(BP_B - BP_A)) %>%
  dplyr::filter(markerDistance > 0 & markerDistance < 200000) %>%
  mutate(intervals = cut_width(markerDistance, 100, boundary = 0)) %>% 
  group_by(intervals) %>% 
  summarise(
    averageR2 = mean(R2, na.rm=TRUE),
    n_pairs = n(),                                         # Count of pairs per window
    se = sd(R2, na.rm=TRUE) / sqrt(n_pairs),               # Standard Error
    ci_lower = averageR2 - (1.96 * se),                    # Lower 95% CI
    ci_upper = averageR2 + (1.96 * se),                    # Upper 95% CI
    midpoint = mean(markerDistance, na.rm=TRUE)            # Midpoint for smooth plotting
  )

# Calculate a scale factor to fit n_pairs onto the 0-1 y-axis of R2
scale_factor <- max(avgLD$n_pairs, na.rm=TRUE)

# Re-create fullLD with the > 0 filter
fullLD <- LD %>% 
  mutate(markerDistance = abs(BP_B - BP_A)) %>%
  dplyr::filter(markerDistance > 0 & markerDistance < 200000) %>% 
  mutate(intervals = cut_width(markerDistance, 100, boundary = 0))

mergedLD <- full_join(fullLD, avgLD, by = "intervals")



# Calculate the statistical baseline (1/n)
# 'n_ind' is actual number of mosquitoes in PLINK file
n_ind <- 158 
theoretical_baseline <- 1/n_ind

# Calculate the observed baseline from the data
# Take the average of the last few bins
observed_baseline <- fullLD %>%
  filter(markerDistance > 150000) %>%
  summarise(baseline = mean(R2, na.rm=TRUE)) %>%
  pull(baseline)

# Calculate the LD Half-Life
# Or the distance where R2 drops halfway between the max and the baseline
max_R2 <- max(avgLD$averageR2)
half_way_point <- (max_R2 + observed_baseline) / 2

# Find the distance closest to this half-way point
ld_decay_distance <- avgLD$midpoint[which.min(abs(avgLD$averageR2 - half_way_point))]

print(paste("Observed Baseline R2:", round(observed_baseline, 4)))
print(paste("LD Half-Life Distance:", round(ld_decay_distance, 2), "bp"))

# Plot
png(file="LD-R2_100bp-window_max200kb-dist.png", units="px", height=3000, width=4000, res=400)

ggplot() + 
  # Raw data points (Grey background)
  geom_point(data=mergedLD, aes(x=markerDistance, y=R2), alpha=0.1, color="grey") + 
  # 95% CI Ribbon
  geom_ribbon(data=avgLD, aes(x=midpoint, ymin=ci_lower, ymax=ci_upper), fill="red", alpha=0.2) +
  # Average LD Line - Map color to a label string
  geom_line(data=avgLD, aes(x=midpoint, y=averageR2, color = "LD (mean R2)"), linewidth=1) +
  # Number of pairs line - Map color to a label string
  geom_line(data=avgLD, aes(x=midpoint, y=n_pairs/scale_factor, color = "Number of Pairs per Window"), 
            linetype="dashed", linewidth=1) +
  # Define the manual colors and the Legend Title
  scale_color_manual(name = NULL, 
                     values = c("LD (mean R2)" = "red", 
                                "Number of Pairs per Window" = "blue")) +
  # Axes and Log Transform
  scale_x_log10(name="log10-transformed marker distance (bp)") +
  scale_y_continuous(
    name = "Linkage Disequilibrium (R2)",
    sec.axis = sec_axis(~ . * scale_factor, name = "Number of Pairs per Window (100bp)")
  ) +
  # Add a horizontal line for the observed baseline
  geom_hline(yintercept = observed_baseline, linetype="dotted", color="black", linewidth=0.8) +
  # Move legend to the bottom for better visibility with a secondary axis
  theme_minimal() +
  theme(legend.position = "bottom")

dev.off()
