library(tidyverse)
library(plotly)

cancer <- as.tibble(read.csv("./Documents/R/Data/HME_USA_COUNTY_CANCER_MORTALITY_RATES_1980_2014_STATES_T_TO_W_CSV/IHME_USA_COUNTY_CANCER_MORTALITY_RATES_1980_2014_WASHINGTON_Y2017M01D24.csv")) %>%
  filter(sex!="Both", location_name!="Washington")

King.County <- filter(cancer, location_name=="King County") %>%
  select('sex', 'year_id', 'cause_name', 'mx') %>%
  as.tibble

neoplasms.kc <- filter(King.County, cause_name=="Neoplasms") %>%
  select('sex', 'year_id', 'mx')
leukemia.kc <- filter(King.County, cause_name=="Leukemia") %>%
  select('sex', 'year_id', 'mx')

# reshape2 library necessary for dcast()
library(reshape2)
prepped.data <- dcast(neoplasms.kc, year_id ~sex)
prepped.data.2 <- dcast(leukemia.kc, year_id ~ sex)

p <- plot_ly(prepped.data, x = ~year_id) %>%
  add_trace(prepped.data, y = ~Female, type = 'bar', name = 'Females') %>%
  add_trace(prepped.data, y = ~Male, type = 'bar', name='Males') %>%
  add_trace(data = prepped.data.2, y = ~Female, type = 'bar', name = 'Females', visible = F) %>%
  add_trace(data = prepped.data.2, y = ~Male, type = 'bar', name='Males', visible = F) %>%
  
  layout(
    title = "Mortality Rates in King County (1980-2014)",
    
    xaxis = list(
      title = "",
      rangeslider = list(type = "date")),
    
    yaxis = list(
      title = 'Mortality Rates'),
    
    updatemenus = list(
      list(
        y = 0.8,
        buttons = list(
          list(method = "restyle",
               args = list("visible", list(TRUE, TRUE, FALSE, FALSE)),
               label = "Neoplasms"),
          
          list(method = "restyle",
               args = list("visible", list(FALSE, FALSE, TRUE, TRUE)),
               label = "Leukemia"))))
  )
