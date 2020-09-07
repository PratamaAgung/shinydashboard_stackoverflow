# Load libraries
library(flexdashboard)
library(dplyr)
library(lubridate)
library(ggplot2)
library(scales)
library(plotly)
library(glue)
library(tidyr)

# package shiny
library(shiny)
library(shinydashboard)

# Data Preprocessing
master_data <- read.csv(file = 'data/stack_overflow_cleaned.csv', quote = '"')
master_data$CreationDate <- ymd_hms(master_data$CreationDate)
master_data <- 
  master_data %>%
    rename(quality = Y) %>%
    mutate(date_only = date(CreationDate))

master_data_agg_daily <- 
  master_data %>%
    group_by(date_only, quality) %>%
    summarise(
      NumberOfQuestion = n()
    ) %>%
    ungroup()

master_data_exploded_tags <-
  master_data %>%
    select('quality', 'CreationDate', 'Tags') %>%
    mutate(tags_split = strsplit(substr(Tags, 2, nchar(Tags)-1), "><")) %>%
    unnest(c(tags_split))

tags_quality <- 
  master_data_exploded_tags %>%
    group_by(tags_split, quality) %>%
    summarise(
      NumberOfQuestion = n()
    ) %>%
    ungroup()


