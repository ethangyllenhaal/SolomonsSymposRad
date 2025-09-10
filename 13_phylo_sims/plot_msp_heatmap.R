library(tidyverse)

# set directory and read inputs
setwd("C:/Documents/Projects/SoloSymposRad/arch_msp/")
raw_input <- read.csv("summarize_buk.txt")
raw_input_makira <- read.csv("summarize_mak.txt")

# process input with different stats
input <- raw_input %>% rowwise() %>%
  mutate(count = sum(c_across(X...B.N..L..K.:Poor.resolution))) %>% # count of finished trees
  mutate(nres = sum(c_across(X...B.N..L..K.:X...L.K..N..B.))) %>% # count of resolved trees
  mutate(true = X...L.K..B..N.) %>% # true topology
  mutate(k_sister = X...B.N..L..K. + X...B.L..N..K. + X...N.L..B..K.) %>% # makira sister
  mutate(other = (count - k_sister - true - Non.monophyletic)) %>% # other patterns
  mutate(x = paste(disp, time, sep="_")) %>% # x axis pair
  mutate(y = paste(ne, int, sep="_")) %>% # y axis pair
  mutate(summary = case_when((Non.monophyletic + Poor.resolution)/count > 0.5 ~ "poor_resolution", # + Poor.resolution for bootstrap version
                             (X...B.N..K..L. + X...B.K..N..L. + X...N.K..B..L.)/nres > 0.5 ~ "L_sis",
                             (X...B.N..L..K. + X...B.L..N..K. + X...N.L..B..K.)/nres > 0.5 ~ "K_sis",
                             (X...B.L..K..N. + X...L.K..B..N. + X...B.K..L..N.)/nres > 0.5 ~ "N_sis",
                             (X...N.L..K..B. + X...N.K..L..B. + X...L.K..N..B.)/nres > 0.5 ~ "B_sis",
                             (X.B.K...N.L. + X.B.N...L.K. + X.B.L...N.K.)/nres > 0.5 ~ "balanced", 
                             .default = "mixed")) %>% # make summaries for plot
  arrange(disp, ne, time, int) # sortting it

# switch to this to separate different Makira sister patterns ####
 # input <- raw_input %>% rowwise() %>%
 #   mutate(count = sum(c_across(X...B.N..L..K.:Poor.resolution))) %>%
 #   mutate(nres = sum(c_across(X...B.N..L..K.:X...L.K..N..B.))) %>%
 #   mutate(true = X...L.K..B..N.) %>%
 #   mutate(k_sister = X...B.N..L..K. + X...B.L..N..K. + X...N.L..B..K.) %>%
 #   mutate(other = (count - k_sister - true - Non.monophyletic)) %>%
 #   mutate(x = paste(disp, time, sep="_")) %>%
 #   mutate(y = paste(ne, int, sep="_")) %>%
 #   mutate(summary = case_when((Non.monophyletic + Poor.resolution)/count > 0.5 ~ "poor_resolution", # + Poor.resolution for bootstrap version
 #                              (X...B.N..K..L. + X...B.K..N..L. + X...N.K..B..L.)/nres > 0.5 ~ "L_sis",
 #                              (X...B.N..L..K.)/nres > 0.5 ~ "K_sis1",
 #                              (X...B.L..N..K.)/nres > 0.5 ~ "K_sis2",
 #                              (X...N.L..B..K.)/nres > 0.5 ~ "K_sis3",
 #                              (X...B.L..K..N. + X...L.K..B..N. + X...B.K..L..N.)/nres > 0.5 ~ "N_sis",
 #                              (X...N.L..K..B. + X...N.K..L..B. + X...L.K..N..B.)/nres > 0.5 ~ "B_sis",
 #                              (X.B.K...N.L. + X.B.N...L.K. + X.B.L...N.K.)/nres > 0.5 ~ "balanced", 
 #                              .default = "mixed")) %>%
 #   arrange(disp, ne, time, int)
 # 
#color_assignments <- c("L_sis" = "#C1B49B", "K_sis1" = "#AA50B4", "K_sis2" = "violet", "K_sis3" = "hotpink",  "N_sis" = "#F06623", "B_sis" = "#009949", "poor_resolution" = "black", "balanced" = "#E6B400", "mixed" = "#1496E6")
#####
# color assignments
color_assignments <- c("L_sis" = "#C1B49B", "K_sis" = "#AA50B4", "N_sis" = "#F06623", "B_sis" = "#009949", "poor_resolution" = "black", "balanced" = "#E6B400", "mixed" = "#1496E6")

# full plot
ggplot(input, aes(x=factor(disp), y=factor(ne))) + 
  geom_tile(aes(fill=summary, alpha=1-(true/count)), color = "white") + 
  facet_wrap(vars(factor(time), factor(int)), nrow=5) +
  scale_fill_manual(values = color_assignments) +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 

# zoomed plot
ggplot(filter(input, time<1000000 & int > 50000 & ! disp %in% c(50,100)), aes(x=factor(disp), y=factor(ne))) + 
  geom_tile(aes(fill=summary, alpha=1-(true/count)), color = "white") + 
  facet_wrap(vars(factor(time), factor(int)), nrow=3) +
  scale_fill_manual(values = color_assignments) +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 

# Makira

# same categories as Bukida first
input_makira <- raw_input_makira %>% rowwise() %>%
  mutate(count = sum(c_across(X...B.N..L..K.:Poor.resolution))) %>%
  mutate(nres = sum(c_across(X...B.N..L..K.:X...L.K..N..B.))) %>%
  mutate(true = X...B.N..L..K.) %>%
  mutate(k_sister = X...B.L..N..K. + X...N.L..B..K.) %>%
  mutate(other = (count - k_sister - true - Non.monophyletic)) %>%
  mutate(x = paste(disp, time, sep="_")) %>%
  mutate(y = paste(ne, int, sep="_")) %>%
  mutate(summary = case_when((Non.monophyletic + Poor.resolution)/count > 0.5 ~ "poor_resolution", # + Poor.resolution for bootstrap version
                             (X...B.N..K..L. + X...B.K..N..L. + X...N.K..B..L.)/nres > 0.5 ~ "L_sis",
                             (X...B.N..L..K. + X...B.L..N..K. + X...N.L..B..K.)/nres > 0.5 ~ "K_sis",
                             (X...B.L..K..N. + X...L.K..B..N. + X...B.K..L..N.)/nres > 0.5 ~ "N_sis",
                             (X...N.L..K..B. + X...N.K..L..B. + X...L.K..N..B.)/nres > 0.5 ~ "B_sis",
                             (X.B.K...N.L. + X.B.N...L.K. + X.B.L...N.K.)/nres > 0.5 ~ "balanced", 
                             .default = "mixed")) %>%
  arrange(disp, ne, time, int)

color_assignments <- c("L_sis" = "#C1B49B", "K_sis" = "#AA50B4", "N_sis" = "#F06623", "B_sis" = "#009949", "poor_resolution" = "black", "balanced" = "#E6B400", "mixed" = "#1496E6")

ggplot(input_makira, aes(x=factor(disp), y=factor(ne))) + 
  geom_tile(aes(fill=summary, alpha=1-(true/50)), color = "white") + 
  facet_wrap(vars(factor(time), factor(int)), nrow=5) +
  scale_fill_manual(values = color_assignments) +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 

ggplot(filter(input_makira, time<1000000 & int > 50000 & ! disp %in% c(50,100)), aes(x=factor(disp), y=factor(ne))) + 
  geom_tile(aes(fill=summary, alpha=1-(true/count)), color = "white") + 
  facet_wrap(vars(factor(time), factor(int)), nrow=3) +
  scale_fill_manual(values = color_assignments) +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 

# parse K sis outcomes

bn_mak <- nrow(filter(input_makira, summary=="K_sis" & X...B.N..L..K. > X...B.L..N..K. & disp>=15))
bl_mak <- nrow(filter(input_makira, summary=="K_sis" & X...B.N..L..K. < X...B.L..N..K. & disp>=15))

bn_buk <-nrow(filter(input, summary=="K_sis" & X...B.N..L..K. > X...B.L..N..K. & disp>=15))
bl_buk <-nrow(filter(input, summary=="K_sis" & X...B.N..L..K. < X...B.L..N..K. & disp>=15))
ksis <- c(bn_mak, bl_mak, bn_buk, bl_buk)
dim(ksis) <- c(2,2)
fisher.test(ksis)

summary_buk <- c(nrow(filter(input, summary=="K_sis")), nrow(filter(input, summary=="balanced")), nrow(filter(input, summary=="N_sis")))
summary_mak <- c(nrow(filter(input_makira, summary=="K_sis")), nrow(filter(input_makira, summary=="balanced")), nrow(filter(input_makira, summary=="N_sis")))
