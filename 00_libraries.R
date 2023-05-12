# 00_libraries.R
library(tidyverse)
library(broom)
library(broom.mixed)
library(modelr)
library(lme4)
library(lmerTest)
library(nlme)
library(emmeans)
library(lubridate)
library(tmap)
library(tmaptools)
library(sf)
library(mapview)
library(DBI)
library(RPostgres)
library(parameters)

# detach("package:reSET", unload = TRUE)
library(reSET)
library(SETr) # Kim Cressman's SET package from GitHub.
library(gganimate)
library(tncThemes)
library(leafsync)
# library(plotly)
library(tmap)
library(tmaptools)
library(crosstalk)
library(gt)
library(knitr)
library(kableExtra)
library(patchwork)
# 
library(arcgisbinding)
arc.check_product()
library("microclimloggers")

library(rmdformats)
library(here)
library(readxl)
library(units)
library(glue)
library(flexplot)

library(tsibble)
library(tsbox)
library(sugrrants)
library(ggrepel)
library(ggiraph)
library(suncalc)
library(extrafont)
library(hrbrthemes)

# Function to calculate the standard error
stder <- function(x){ sqrt(var(x,na.rm=TRUE)/length(na.omit(x)))}

# refresh reSET package
resetr <- function(){detach("package:reSET", unload = TRUE)
  library(reSET)}

# sample entire set of a random group (from group_by variable)
sample_n_groups <- function(tbl, size, replace = FALSE, weight = NULL) {
  # regroup when done
  grps = tbl %>% groups %>% lapply(as.character) %>% unlist
  # check length of groups non-zero
  keep = tbl %>% summarise() %>% ungroup() %>% sample_n(size, replace, weight)
  # keep only selected groups, regroup because joins change count.
  # regrouping may be unnecessary but joins do something funky to grouping variable
  tbl %>% right_join(keep, by=grps) %>% group_by_(.dots = grps)
}
