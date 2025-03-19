# server.R
# Server logic for Great Barrier Reef Aragonite Analysis

# Load required packages
library(shiny)
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyverse)
library(gtools)

# Server function
function(input, output, session) {
  
  # Load sample data or create mock data
  data_source <- reactiveVal("Sample data not found. Using generated data.")
  merge_all <- reactive({
    # Try to load sample data
    if (file.exists("sample_data.rds")) {
      data_source("Using sample data from sample_data.rds")
      return(readRDS("sample_data.rds"))
    } else {
      # Create mock data if sample data is not found
      data_source("No sample data found. Using mock data.")
      return(create_mock_data())
    }
  })
  
  # Function to create mock data if no sample data is available
  create_mock_data <- function() {
    # Set seed for reproducibility
    set.seed(123)
    
    # Create grid of coordinates covering the Great Barrier Reef area
    latitudes <- seq(-19, -16, by = 0.1)
    longitudes <- seq(145, 147, by = 0.1)
    grid <- expand.grid(longitude = longitudes, latitude = latitudes)
    
    # Number of years
    years <- 2015:2019
    
    # Create a data frame with all combinations of coordinates and years
    data_list <- list()
    
    for (year in years) {
      # Create data for one year
      year_data <- grid
      
      # Add environmental variables with some spatial correlation
      year_data$finesed <- 0.0001 + 0.00005 * abs(sin(year_data$latitude * 10)) + 
        0.00001 * rnorm(nrow(year_data))
      
      year_data$salinity <- 35 + 0.5 * cos(year_data$longitude/10) + 
        0.2 * rnorm(nrow(year_data))
      
      year_data$macroalgae_production <- 1 + 0.5 * sin(year_data$latitude * 5) + 
        0.2 * rnorm(nrow(year_data))
      
      year_data$temp <- 26 + 1.5 * sin((year_data$latitude + 20) * 2) + 
        0.5 * cos(year_data$longitude/10) + 0.3 * rnorm(nrow(year_data))
      
      year_data$mean_wspeed <- 5 + 1.5 * cos(year_data$latitude * 3) + 
        0.5 * sin(year_data$longitude/8) + 0.5 * rnorm(nrow(year_data))
      
      # Add year
      year_data$year <- year
      
      # Calculate aragonite
      year_data$aragonite <- calculate_aragonite(
        year_data$finesed,
        year_data$salinity,
        year_data$macroalgae_production,
        year_data$temp,
        year_data$mean_wspeed,
        year_data$latitude,
        year_data$longitude
      )
      
      # Add to list
      data_list[[as.character(year)]] <- year_data
    }
    
    # Combine all years
    all_data <- do.call(rbind, data_list)
    
    return(all_data)
  }
  
  # Calculate aragonite based on formula
  calculate_aragonite <- function(finesed, salinity, macroalgaeProduction, temp, meanWSpeed, latitude, longitude) {
    # Model to predict aragonite 
    aragonite = 6.826e+00 + (finesed * -1.844e+05) + 
      (salinity * -8.612e-02) + 
      (macroalgaeProduction * -5.998e+00) + 
      (temp * 1.637e-02) + 
      (meanWSpeed * -1.355e-02) + 
      (latitude * 5.464e-03) + 
      (longitude * -2.921e-03)
    
    return(aragonite)
  }
  
  # Calculate average values for each property
  average_values <- reactive({
    data <- merge_all()
    
    list(
      salinity = mean(data$salinity, na.rm = TRUE),
      temp = mean(data$temp, na.rm = TRUE),
      finesed = mean(data$finesed, na.rm = TRUE),
      macroalgae_production = mean(data$macroalgae_production, na.rm = TRUE),
      mean_wspeed = mean(data$mean_wspeed, na.rm = TRUE)
    )
  })
  
  # Create a function to calculate the radius based on the aragonite level
  calculate_radius <- function(aragonite) {
    ifelse(aragonite >= 3, 10,
           ifelse(aragonite < 3 & aragonite > 1, 20, 30))
  }
  
  # Create a function to assign a color based on the aragonite level
  assign_color <- function(aragonite) {
    ifelse(aragonite >= 3, "lightgreen",
           ifelse(aragonite < 3 & aragonite > 1, "orange", "red"))
  }
  
  # Returns a data record based on lat and lng
  get_point_data <- function(lat, lng) {
    data <- filtered_data()
    
    #default to most current year if all
    if(input$year == 'all'){
      yr <- max(data$year, na.rm = TRUE)
    } else{
      yr <- as.numeric(input$year)
    }
    
    # Find the closest point in the dataset
    point <- data %>% 
      filter(year == yr) %>%
      mutate(distance = sqrt((latitude - lat)^2 + (longitude - lng)^2)) %>%
      arrange(distance) %>%
      slice(1)
    
    return(point)
  }
  
  # Filter data based on selected year
  filtered_data <- reactive({
    data <- merge_all()
    
    if(input$year == 'all'){
      return(data)
    } else {
      return(data %>% filter(year == as.numeric(input$year)))
    }
  })
  
  # Show data source info (only visible in development)
  output$data_source_info <- renderText({
    data_source()
  })
  
  # Render Map
  output$reefmap <- renderLeaflet({
    data <- filtered_data()
    
    leaflet(data) %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      setView(lng = 146, lat = -17.5, zoom = 7) %>%
      addCircleMarkers(~longitude, ~latitude, 
                       label = ~paste("Aragonite:", round(aragonite, 2)),
                       radius = ~calculate_radius(aragonite),
                       clusterOptions = markerClusterOptions(),
                       color = ~sapply(aragonite, assign_color),
                       stroke = FALSE, fillOpacity = 0.5)
  })
  
  # Observe the marker click event
  observeEvent(input$reefmap_marker_click, {
    # Get the coordinates of the click
    lat <- input$reefmap_marker_click$lat
    lng <- input$reefmap_marker_click$lng
    
    # Get data for the clicked point
    point_data <- get_point_data(lat, lng)
    
    # Update input values
    updateNumericInput(session, "latitude", value = point_data$latitude)
    updateNumericInput(session, "longitude", value = point_data$longitude)
    updateNumericInput(session, "temp", value = point_data$temp)
    updateNumericInput(session, "finesed", value = point_data$finesed)
    updateNumericInput(session, "salinity", value = point_data$salinity)
    updateNumericInput(session, "macroalgaeProduction", value = point_data$macroalgae_production)
    updateNumericInput(session, "meanWSpeed", value = point_data$mean_wspeed)
  })
  
  # Filter by year and update map
  observe({
    data <- filtered_data()
    
    # Display aragonite value with appropriate color
    output$aragonite <- renderUI({
      aragonite <- result_text()
      
      if (is.na(aragonite)) {
        HTML('<h3 style="color:gray;">No data</h3>')
      } else if (aragonite >= 3) {
        HTML(paste('<h3 style="color:#34a853;">', round(aragonite, 2), '</h3>'))
      } else if (aragonite > 1 && aragonite < 3) {
        HTML(paste('<h3 style="color:#f8bd49;">', round(aragonite, 2), '</h3>'))
      } else {
        HTML(paste('<h3 style="color:#ea4335;">', round(aragonite, 2), '</h3>'))
      }
    })
    
    # Update map with filtered data
    proxy <- leafletProxy("reefmap", data = data)
    
    # Remove any existing controls
    proxy %>% clearControls()
    
    # Update markers based on clustering preference
    if (input$showClusters == "TRUE") {
      proxy %>% clearMarkers()
      proxy %>% addCircleMarkers(~longitude, ~latitude, 
                                label = ~paste("Aragonite:", round(aragonite, 2)),
                                radius = ~calculate_radius(aragonite),
                                clusterOptions = markerClusterOptions(),
                                color = ~sapply(aragonite, assign_color),
                                stroke = FALSE, fillOpacity = 0.5)
    } else {
      proxy %>% clearMarkers()
      proxy %>% clearMarkerClusters()
      proxy %>% addCircleMarkers(~longitude, ~latitude, 
                                label = ~paste("Aragonite:", round(aragonite, 2)),
                                radius = ~calculate_radius(aragonite),
                                color = ~sapply(aragonite, assign_color),
                                stroke = FALSE, fillOpacity = 0.5)
    }
  })
  
  # Handle map clicks for adding new points
  observeEvent(input$reefmap_click, {
    lat <- input$reefmap_click$lat
    lng <- input$reefmap_click$lng
    
    updateNumericInput(session, "add_latitude", value = lat)
    updateNumericInput(session, "add_longitude", value = lng)
  })
  
  # Add new point button handler
  observeEvent(input$btn_add_point, {
    data <- filtered_data()
    avg <- average_values()
    
    # Get coordinates for new point
    lat <- input$add_latitude
    lng <- input$add_longitude
    
    # Create a new row with default values
    new_row <- data.frame(
      latitude = lat,
      longitude = lng,
      finesed = avg$finesed,
      salinity = avg$salinity,
      macroalgae_production = avg$macroalgae_production,
      temp = avg$temp,
      mean_wspeed = avg$mean_wspeed,
      year = ifelse(input$year == 'all', max(data$year, na.rm = TRUE), as.numeric(input$year))
    )
    
    # Calculate aragonite for new point
    new_row$aragonite <- calculate_aragonite(
      new_row$finesed, 
      new_row$salinity, 
      new_row$macroalgae_production, 
      new_row$temp, 
      new_row$mean_wspeed, 
      new_row$latitude, 
      new_row$longitude
    )
    
    # Add new row to filtered data
    data <- rbind(data, new_row)
    
    # Update map
    proxy <- leafletProxy("reefmap", data = data)
    proxy %>% clearMarkers()
    proxy %>% clearMarkerClusters()
    
    if (input$showClusters == "TRUE") {
      proxy %>% addCircleMarkers(~longitude, ~latitude,  
                              label = ~paste("Aragonite:", round(aragonite, 2)),
                              radius = ~calculate_radius(aragonite),
                              clusterOptions = markerClusterOptions(),
                              color = ~sapply(aragonite, assign_color),
                              stroke = FALSE, fillOpacity = 0.5)
    } else {
      proxy %>% addCircleMarkers(~longitude, ~latitude,  
                              label = ~paste("Aragonite:", round(aragonite, 2)),
                              radius = ~calculate_radius(aragonite),
                              color = ~sapply(aragonite, assign_color),
                              stroke = FALSE, fillOpacity = 0.5)
    }
    
    # Update input fields with new point data
    updateNumericInput(session, "latitude", value = lat)
    updateNumericInput(session, "longitude", value = lng)
    updateNumericInput(session, "temp", value = new_row$temp)
    updateNumericInput(session, "finesed", value = new_row$finesed)
    updateNumericInput(session, "salinity", value = new_row$salinity)
    updateNumericInput(session, "macroalgaeProduction", value = new_row$macroalgae_production)
    updateNumericInput(session, "meanWSpeed", value = new_row$mean_wspeed)
  })
  
  # Calculate aragonite based on input values
  result_text <- reactive({
    aragonite <- calculate_aragonite(
      input$finesed,
      input$salinity,
      input$macroalgaeProduction,
      input$temp,
      input$meanWSpeed,
      input$latitude,
      input$longitude
    )
    
    return(aragonite)
  })
  
  # Reset filters button handler
  observeEvent(input$resetFilters, {
    updateSelectInput(session, "year", selected = "all")
    updateSelectInput(session, "showClusters", selected = "TRUE")
  })
  
  # Calculate risk button handler
  observeEvent(input$calculateRisk, {
    # This is just to trigger the aragonite output to update
    # The calculation happens in the result_text reactive
  })
}