library(shiny)
library(dplyr)
library(ggplot2)
library(RColorBrewer)
library(ggeasy)
library(maps)
library(mapproj)
library(countrycode)
library(plotly)

# library("rsconnect")

source("app_ui.R")
source("app_server.R")

shinyApp(ui = ui, server = server)