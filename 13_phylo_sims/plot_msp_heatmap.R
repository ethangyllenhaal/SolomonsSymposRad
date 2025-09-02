library(tidyverse)

setwd("C:/Documents/Projects/SoloSymposRad/arch_msp/")
raw_input <- read.csv("summarize_buk.txt")
raw_input_makira <- read.csv("summarize_mak.txt")

input <- raw_input %>% rowwise() %>%
  mutate(count = sum(c_across(X...B.N..L..K.:Poor.resolution))) %>%
  mutate(nres = sum(c_across(X...B.N..L..K.:X...L.K..N..B.))) %>%
  mutate(true = X...L.K..B..N.) %>%
  mutate(k_sister = X...B.N..L..K. + X...B.L..N..K. + X...N.L..B..K.) %>%
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
# switch to this to separate different Makira sister ####
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

color_assignments <- c("L_sis" = "#C1B49B", "K_sis" = "#AA50B4", "N_sis" = "#F06623", "B_sis" = "#009949", "poor_resolution" = "black", "balanced" = "#E6B400", "mixed" = "#1496E6")

ggplot(input, aes(x=factor(disp), y=factor(ne))) + 
  geom_tile(aes(fill=summary, alpha=1-(true/count)), color = "white") + 
  facet_wrap(vars(factor(time), factor(int)), nrow=5) +
  scale_fill_manual(values = color_assignments) +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 

ggplot(filter(input, time<1000000 & int > 50000 & ! disp %in% c(50,100)), aes(x=factor(disp), y=factor(ne))) + 
  geom_tile(aes(fill=summary, alpha=1-(true/count)), color = "white") + 
  facet_wrap(vars(factor(time), factor(int)), nrow=3) +
  scale_fill_manual(values = color_assignments) +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 

# Makira

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

## JOBTALK

input_talk <- raw_input %>%
  mutate(true = X...L.K..B..N.) %>%
  mutate(k_sister = X...B.N..L..K. + X...B.L..N..K. + X...N.L..B..K.) %>%
  mutate(other = (50 - k_sister - true - Non.monophyletic)) %>%
  mutate(x = paste(disp, ne, sep="_")) %>%
  mutate(y = paste(time, int, sep="_")) %>%
  mutate(summary = case_when(Non.monophyletic + Poor.resolution > 20 ~ "poor_resolution", # + Poor.resolution for bootstrap version
                             X...B.N..K..L. + X...B.K..N..L. + X...N.K..B..L. > 30 ~ "L_sis",
                             X...B.N..L..K. + X...B.L..N..K. + X...N.L..B..K. > 30 ~ "K_sis",
                             X...B.L..K..N. + X...L.K..B..N. + X...B.K..L..N. > 30 ~ "N_sis",
                             X...N.L..K..B. + X...N.K..L..B. + X...L.K..N..B. > 30 ~ "B_sis",
                             X.B.K...N.L. + X.B.N...L.K. + X.B.L...N.K. > 30 ~ "balanced", 
                             .default = "mixed")) %>%
  arrange(disp, int, time, ne)

#color_assignments <- c("L_sis" = "#C1B49B", "K_sis" = "#CC79A7", "N_sis" = "#D55E00", "B_sis" = "#61D04F", "poor_resolution" = "black", "balanced" = "#E69F00", "mixed" = "#0072B2")
color_assignments <- c("L_sis" = "#C1B49B", "K_sis" = "#AA50B4", "N_sis" = "#F06623", "B_sis" = "#009949", "poor_resolution" = "black", "balanced" = "#E6B400", "mixed" = "#1496E6")

ggplot(input_talk, aes(x=factor(disp), y=factor(int))) + 
  geom_tile(aes(fill=summary, alpha=1-(true/50)), color = "white") + 
  facet_wrap(vars(factor(time), factor(ne)), nrow=5) +
  scale_fill_manual(values = color_assignments) +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 


## old test  ####

true <- c(20,10,0,0,5,5)
k <- c(0,10,20,10,5,15)
other <- c(0,0,0,10,10,0)

df <- data.frame(true, k, other)


df_color <- df %>%
  mutate(color = rgb(red=k/20, blue=other/20, green = 0, alpha = 1- true/20))

x <- seq(1,6)
y <- seq(1)
grid <- expand.grid(x,y)
grid$colors <- rep(df_color$color, 1)

ggplot(grid, aes(x=Var1, y=Var2)) + geom_tile(aes(fill=colors)) + scale_fill_manual(values = unique(df_color$color))

df$x <- grid$Var1
df$y <- grid$Var2

ggplot(df, aes(x=x, y=y)) + geom_tile(aes(fill=k, alpha=1-true)) + scale_fill_gradient(low = "black", high="purple")



# other old versions


ggplot(input, aes(x=factor(x), y=factor(y))) + 
  geom_tile(aes(fill=k_sister - other, alpha=1-(true/20)), color = "white") + 
  scale_fill_gradient2(low = "orange",  mid = "black", high="purple") +
  theme_classic()

ggplot(input, aes(x=factor(time), y=factor(int))) + 
  geom_tile(aes(fill=k_sister/(k_sister+other), alpha=1-(true/20)), color = "white") + 
  facet_wrap(vars(factor(ne), factor(disp)), nrow=3) +
  scale_fill_gradient(low = "orange",  high="darkmagenta") +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 

ggplot(input, aes(x=factor(time), y=factor(int))) + 
  geom_tile(aes(fill=summary, alpha=1-(true/20)), color = "white") + 
  facet_wrap(vars(factor(ne), factor(disp)), nrow=3) +
  scale_fill_manual(values = color_assignments) +
  theme(strip.background = element_blank(), strip.text.x = element_blank(), panel.background = element_blank(), panel.spacing = unit(0.2, "lines")) 
