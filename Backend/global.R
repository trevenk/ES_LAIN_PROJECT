library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(dashboardthemes)
library(shinybusy)
library(shinyalert)
library(shinyWidgets)
library(stringr)
library(lubridate)
library(tibble)
library(ggplot2)
library(ggiraph)
library(rlang)
library(r.ETH)
library(aws.s3)
library(jsonlite)
library(DT)

### source the sources
# Classes & Methods
source('../Security/Security.R')
source('methods.R')
### Call the modules ###

source("modules/BigSelector.R")
source("modules/StaticTable.R")
source("modules/LinePlotWithFilters.R")
source("modules/LinesSelector.R")
source("modules/AllInfoToken.R")
source("modules/StaticTableForEntity.R")


#### This are default values for runing a complete beta ui ###
today <- today()

main_selector_options <- tryCatch({
  token_index_card <<- s3read_using(fromJSON, object = "Lain/Tokens/token_index_card.json", bucket = "andres-crypto-bucket")
  c(token_index_card$symbol)
}, error = function(e) {
  c('KAI', 'SUSHI')
})

token_info <- tryCatch({
  s3read_using(fromJSON, object = "Lain/Tokens/token_info.json", bucket = "andres-crypto-bucket")
}, error = function(e) {
  data.frame("name" = c('KAI', 'SUSHI', 'OTRODEPRUEBA'),
             'precio' = c(1, 2, 3),
             'precio_7' = c(2, 3, 1),
             'precio_30' = c(3, 5, 4),
             'exchanges' = c(12, 14, 32),
             'exchanges_7' = c(14, 5, 56),
             'exchanges_30' = c(12, 2, 24))
})

main_table <- token_info[token_info$date_time == today, ]
this_token <- "KAI"

traced <-  s3read_using(fromJSON, object = "Lain/Holders/Traced/traced_info.json", bucket = "andres-crypto-bucket")
exchanges <- s3read_using(fromJSON, object = "Lain/Exchanges/exchange_info.json", bucket = "andres-crypto-bucket")


