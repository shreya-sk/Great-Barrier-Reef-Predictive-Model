# app.R
# Combined UI and server for Great Barrier Reef Aragonite Analysis

# Load required packages
library(shiny)

# Source UI and server files
source("ui.R")
source("server.R")

# Run the application
shinyApp(ui = ui, server = server)