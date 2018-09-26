library(haven)
library(tidyr)
library(dplyr)
coverage = read.csv("coverage.csv", skip = 2, nrows = 52, check.names = FALSE)
coverage = mutate(coverage, order = c(1:length(coverage$Location)))
expenditures = read.csv("expenditures.csv", skip = 2, nrows = 52, check.names = FALSE)
expenditures = mutate(expenditures, order = c(1:length(expenditures$Location)))

## Make "coverage" data tidy

coverage_tidy = coverage %>%
  gather(year_group, coverage, -Location, -order) %>%
  arrange(Location) %>%
  separate(year_group, c("year", "group"))
coverage_tidy$group[coverage_tidy$group == "Non"] = "Non-Group"
coverage_tidy$group[coverage_tidy$group == "Other"] = "Other Public"

## Make "expenditures" data tidy

expenditures_tidy = expenditures %>%
  gather(year_spending, totalSpending, -Location, -order) %>%
  arrange(Location) %>%
  separate(year_spending, c("year", "spending"))
expenditures_tidy$spending <- NULL


## Merge two data frames
expenditures_tidy = expenditures_tidy[expenditures_tidy$year > 2012,]
info = merge(coverage_tidy, expenditures_tidy, 
             by=c("Location", "year", "order"), all = TRUE)
info = arrange(info, order)
info$order <- NULL
