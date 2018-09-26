library(haven)
library(tidyr)
library(dplyr)
library(ggplot2)
data = read.csv("lab2.csv")

data_tidy = data %>%
  gather(time_cate, score, -patient_id) %>%
  arrange(patient_id) %>%
  separate(time_cate, c("time", "cate"))

info = select(data_tidy, time, cate, score) %>% 
  group_by(time, cate) %>%
  summarise_all(funs(mean,sd))

info %>%
  mutate(min = mean-sd, max = mean + sd) %>%
  group_by(cate) %>%
  ggplot(aes(x = time, y = mean, color = cate, group = cate)) +
  geom_point() +
  geom_errorbar(aes(ymin = min, ymax = max, width = 0.05)) +
  geom_line() +
  theme_bw() +
  labs(x = "Time of report", y = "Sample Mean and Standard Diviation", color = "category")
