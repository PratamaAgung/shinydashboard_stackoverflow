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

# Aggregate data into daily basis to be shown in trend plot
master_data_agg_daily <- 
  master_data %>%
    group_by(date_only, quality) %>%
    summarise(
      NumberOfQuestion = n()
    ) %>%
    ungroup()

# Creating tag-quality data format
## Explode the question with multiple tags into multiple row
master_data_exploded_tags <-
  master_data %>%
    select('quality', 'CreationDate', 'Tags') %>%
    mutate(tags_split = strsplit(substr(Tags, 2, nchar(Tags)-1), "><")) %>%
    unnest(c(tags_split))

## Aggregate data on each tag quality
tags_quality_data <- 
  master_data_exploded_tags %>%
    group_by(tags_split, quality) %>%
    summarise(
      NumberOfQuestion = n()
    ) %>%
    ungroup()


