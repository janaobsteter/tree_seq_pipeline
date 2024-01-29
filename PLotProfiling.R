library(ggplot2)
library(viridis)
library(dplyr)
library(plyr)
library(tidyr)

t = read.csv("~/EddieDir/jobsteter/Honeybees/ScaleUpAnalyis_Tsinfer/Profiling.csv")
t$method <- factor(t$method, levels = c("UnspecifiedParameters", "SpecifiedParameters", "SpecifiedParameters_3Stages"))

# Plot these numbers
# Compare all three methods for 1 and 8 threads
# Prepare a dataframe for plotting
t_plot <- t %>%  filter(threads %in% c(1, 8)) %>% filter(Chr == "Chr16") %>%  select(noSamples, meanRAM, maxRAM, time, method, threads) %>% 
  pivot_longer(cols = c(meanRAM, maxRAM, time))

ggplot(data = t_plot, aes(x = noSamples, y = value, colour = method)) + 
  geom_point() + 
  geom_line(linewidth = 0.7) + 
  facet_grid(cols = vars(threads), rows = vars(name)) + 
  scale_colour_manual(values = c("#FCA50AFF", "#420A68FF", "#DD513AFF")) + 
  theme_bw(base_size = 14) + 
  theme(panel.grid.major = element_blank())

t_plot1a <- t %>%  filter(threads %in% c(8)) %>% filter(Chr == "Chr16") %>%  select(noSamples, noTrees, noMutations, method) %>% 
  pivot_longer(cols = c(noTrees, noMutations))
t_plot1a$name <- factor(t_plot1a$name, levels = c("noTrees", "noMutations"))
  
ggplot(data = t_plot1a, aes(x = as.factor(noSamples), y = value, group = method, fill = method)) + 
  geom_col(position = "dodge") + 
  facet_grid(rows = vars(name)) + 
  xlab("No samples") + ylab("") + 
  scale_fill_manual("", values = c("#FCA50AFF", "#420A68FF", "#DD513AFF")) + 
  theme_bw(base_size = 14) + 
  theme(panel.grid.major = element_blank())



# Compare only the "Specified_3Stage" on 1, 8, 16, 32 threads
t_plot1 <- t %>%  filter(method == "SpecifiedParameters_3Stages") %>%  filter(Chr == "Chr16") %>% select(noSamples, meanRAM, maxRAM, time, threads) %>% 
  pivot_longer(cols = c(meanRAM, maxRAM, time))

t_plot1$name <- plyr::revalue(t_plot1$name, c("maxRAM" = "max RAM [Gb]", "meanRAM" = "mean RAM [Gb]", "time" = "Time [h]"))

ggplot(data = t_plot1, aes(x = noSamples, y = value, colour = as.factor(threads))) + 
  geom_point() + 
  geom_line(linewidth = 0.7) + 
  facet_grid(cols = vars(name)) + 
  xlab("No samples") + ylab("Value") + 
  scale_colour_manual("Threads", values = c("#FCA50AFF", "#DD513AFF","#82206CFF", "#420A68FF")) + 
  theme_bw(base_size = 14) 


# Compare chromosome 7 (890,000 sites) and chromosome 6 (447,000 sites)
t_plot2 <- t %>%  filter(method == "SpecifiedParameters_3Stages") %>%  select(Chr, noSamples, meanRAM, maxRAM, time, threads) %>% 
  pivot_longer(cols = c(meanRAM, maxRAM, time))

t_plot2$name <- plyr::revalue(t_plot2$name, c("maxRAM" = "max RAM [Gb]", "meanRAM" = "mean RAM [Gb]", "time" = "Time [h]"))

ggplot(data = t_plot2, aes(x = noSamples, y = value, colour = Chr)) + 
  geom_point() + 
  geom_line() + 
  facet_grid(cols = vars(name), rows = vars(threads)) + 
  xlab("No samples") + ylab("Value") + 
  scale_colour_manual("Threads", values = c("#FCA50AFF", "#82206CFF")) + 
  theme_bw(base_size = 14) 

# Compare to when the mismatch ratio was 1
mismatch1 <- read.csv("~/Nextcloud/Documents/1Projects/HoneybeeDemography/ScaleUp_Tsinfer.csv")
mismatch1 <- mismatch1 %>%  filter(Method %in% c("Specified", "Specified_3Stage")) %>% 
  select (noSamples, noTrees, meanRAM, maxRAM, Time.h., Threads, Method, MismatchRatio)
head(mismatch1)
mismatch0.1 <- t %>% filter(method %in% c("SpecifiedParameters", "SpecifiedParameters_3Stages")) %>%  filter(Chr == "Chr16") %>% 
  select(noSamples, noTrees, meanRAM, maxRAM, time, threads, method) %>%  mutate(mismatchRatio = 0.1)
colnames(mismatch1) <- colnames(mismatch0.1)
mismatch1$method <- plyr::revalue(mismatch1$method, c("Specified" = "SpecifiedParameters",
                                                      "Specified_3Stage" = "SpecifiedParameters_3Stages"))

compare <- bind_rows(mismatch0.1, mismatch1)

t_plot3 <- compare %>%  filter(method == "SpecifiedParameters_3Stages") %>%  select(noSamples, meanRAM, maxRAM, time, threads, mismatchRatio) %>% 
  pivot_longer(cols = c(meanRAM, maxRAM, time))

t_plot3$name <- plyr::revalue(t_plot3$name, c("maxRAM" = "max RAM [Gb]", "meanRAM" = "mean RAM [Gb]", "time" = "Time [h]"))

ggplot(data = t_plot3, aes(x = noSamples, y = value, colour = as.factor(mismatchRatio))) + 
  geom_point() + 
  geom_line() + 
  facet_grid(cols = vars(name), rows = vars(threads)) + 
  xlab("No samples") + ylab("Value") + 
  scale_colour_manual("Threads", values = c("#FCA50AFF", "#82206CFF")) + 
  theme_bw(base_size = 14) 

ggplot(data = compare %>% filter(threads == 8), aes(x = as.factor(noSamples), y = noTrees, fill = as.factor(mismatchRatio))) + 
  geom_col(position = "dodge") + 
  xlab("No samples") + ylab("No trees") + 
  scale_fill_manual("Mismatch ratio", values = c("#FCA50AFF", "#420A68FF", "#DD513AFF")) + 
  theme_bw(base_size = 14) + 
  theme(panel.grid.major = element_blank())
