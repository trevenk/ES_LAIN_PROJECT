library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(shinybusy)
library(stringr)
library(lubridate)
library(tibble)

### source the sources
# Classes & Methods

### Call the modules ###

source("modules/BigSelector.R")
source("modules/StaticTable.R")

#### This are default values for runing a complete beta ui ###

main_selector_options <- tryCatch({
  recogertokensdeamazon()
}, error = function(e) {
  c('KAI', 'SUSHI')
})

token_info <- tryCatch({
  recogertodoslostokendesdeamazon()
}, error = function(e) {
  data.frame("name" = c('KAI', 'SUSHI', 'OTRODEPRUEBA'),
             'precio' = c(1, 2, 3),
             'precio_7' = c(2, 3, 1),
             'precio_30' = c(3, 5, 4),
             'exchanges' = c(12, 14, 32),
             'exchanges_7' = c(14, 5, 56),
             'exchanges_30' = c(12, 2, 24))
})
