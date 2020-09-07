# Load libraries
library(flexdashboard)
library(dplyr)
library(lubridate)
library(ggplot2)
library(scales)
library(plotly)
library(glue)

# package shiny
library(shiny)
library(shinydashboard)

# Data Preprocessing
master_data <- read.csv(file = 'data/stack_overflow.csv', quote = '"')
master_data$CreationDate <- ymd_hms(master_data$CreationDate)
master_data <- 
  master_data %>%
    rename(quality = Y) %>%
    select(-Body) %>%
    mutate(date_only = date(CreationDate))

master_data_agg_daily <- 
  master_data %>%
    group_by(date_only, quality) %>%
    summarise(
      NumberOfQuestion = n()
    ) %>%
    ungroup()

