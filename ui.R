# Enhanced UI for Great Barrier Reef Aragonite Analysis that matches the style of the 3888 app

# Load required packages
library(shiny)
library(remotes)
library(fullPage)
library(leaflet)

# Define color scheme for the application
options <- list(
  sectionsColor = c(
    "#C3F3EC",             # Welcome
    "#d9d9d9",             # About
    "#d9d9d9",             # Data
    "#d9d9d9",             # Risk Calculator
    "#C3F3EC",             # Additional section (if needed)
    "#FFFFFF",             # Additional section (if needed)
    "#FE9199",             # Additional section (if needed)
    "#FFADB2"              # Additional section (if needed)
  )
)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fullPage(
  center = TRUE,
  opts = options,
  menu = c(
    "Welcome" = "intro",
    "About" = "about",
    "Data" = "data",
    "Risk Calculator" = "map"
  ),
  fullSectionImage( # will not show in viewer, open in browser
    menu = "intro",
    img = paste0(
      "https://images.unsplash.com/photo-1439405326854-014607f694d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3540&q=80"),
    h1("Conservation Project", style="color:white; font-size:80px;"),
    h1("Marine and Data Science", style="color:white; font-size:80px;")
  ),
  fullSection(
    menu = "about",
    fullContainer(
      h1("About", style="margin-bottom:30px;"),
      h3("Purpose"),
      p("Our data project aims to contribute to the conservation efforts of coral reefs by leveraging advanced machine learning techniques to predict aragonite levels. Collaborating with marine science students, we combine their theoretical knowledge of aragonite with our expertise in data analysis and modeling. This interdisciplinary approach allows us to address the challenges faced by these delicate ecosystems from a data-driven standpoint."),
      p("Our project focuses on predicting the aragonite levels in coral reefs using a combination of two datasets. Aragonite, a critical component of coral reef structures, has a profound impact on reef accretion and erosion processes. By accurately predicting aragonite levels, we can gain valuable insights into the potential for reef growth or degradation in different areas, aiding in effective conservation planning."),
      h3("Client", style="margin-top:30px;"),
      p("Great Barrier Marine Park Authority"),
      h3("Product", style="margin-top:30px;"),
      p("A risk calculator for determining whether the classifications of coral zoning areas require adjustment"),
      h3("Team", style="margin-top:30px;"),
      p("James Agamemnonos, Adda Ding, Jasmine Glencross, Kade Jansen-Daniel, Shreya Kothari, Shiyuan Li, Hangrui Shi, Simon Um"),
    )
  ),
  fullSection(
    menu = "data",
    fullContainer(
      h1("Data"),
      fullRow(
          h2("Description"),
          p("The data combines environmental measurements from the eReefs project monitoring the Great Barrier Reef. Data includes biogeochemical and hydrodynamic parameters collected from 2015 to 2019.", style = "margin-bottom:50px"),
          h2("Linear Model"),
          p("This data frame contains the following columns:", style = "margin-bottom:50px")  
      ),
      fullRow(
        fullColumn(
          p("aragonite", style="font-family:monospace"),
          p("latitude", style="font-family:monospace"),
          p("longitude", style="font-family:monospace"),
          p("temp", style="font-family:monospace"),
          p("finesed", style="font-family:monospace"),
          p("salinity", style="font-family:monospace"),
          p("macroalgae_production", style="font-family:monospace"),
          p("mean_wspeed", style="font-family:monospace"),
        ),
        fullColumn(
          p("Levels of aragonite measured."),
          p("Latitude value recorded."),
          p("Longitude value recorded."),
          p("Temperature level recorded in degrees celsius."),
          p("Levels of fine sediment recorded at the site."),
          p("Level of salinity recorded in grams per litre."),
          p("Levels of macroalgae production."),
          p("Average wind speed."),
        )
      ),
    )
  ),
  fullSection(
    menu = "map",
    center = FALSE,
    fullContainer(
      tags$style(type = "text/css", "#reefmap {background-color: #d9d9d9 !important; margin-top: 60px; height: calc(100vh - 200px) !important;} .leaflet-container {background: #d9d9d9 !important;}"),
      leafletOutput("reefmap"),
      fluidRow(verbatimTextOutput("Click_text")),
    
      absolutePanel(
        top = 100,
        left = 10,
        style = "background-color: #fff; color: #000; border-radius: 20px; padding: 20px; margin-bottom: 10px", 
        h2("Filters", style = "color:black"),
        selectInput(
          "year",
          "Year",
          c("All" = "all",
            "2019" = "2019",
            "2018" = "2018",
            "2017" = "2017",
            "2016" = "2016",
            "2015" = "2015"),
          selected = "all",
          multiple = FALSE,
          selectize = TRUE,
          width = 200,
          size = NULL
        ),
        selectInput(
          "showClusters",
          "Clustering",
          c("On" = "TRUE",
            "Off" = "FALSE"),
          selected = "TRUE",
          multiple = FALSE,
          selectize = TRUE,
          width = 200,
          size = NULL
        )
      ),
      absolutePanel(
        top = 430,
        left = 10,
        width = 240,
        style = "background-color: #fff; color: #000; border-radius: 20px; padding: 20px; margin-bottom: 10px", 
        h2("Add Point", style = "color:black"),
        p("Click on the map or input a latitude and longitude to add a new data point at that location."),
        numericInput("add_latitude", "Latitude", 0, width = 200),
        numericInput("add_longitude", "Longitude", 0, width = 200),
        actionButton("btn_add_point", "Add")
      ),
      absolutePanel( 
        top = 100,
        right = 10,
        style = "background-color: #fff; color: #000; border-radius: 20px; padding: 20px;", 
        h2("Risk Calculator", style = "color:black"),
        uiOutput("aragonite"),
        hr(),
        numericInput("latitude", "Latitude", 0, width = 200),
        numericInput("longitude", "Longitude", 0, width = 200),
        numericInput("finesed", "Finesed", 0, width = 200),
        numericInput("salinity", "Salinity", 0, width = 200),
        numericInput("macroalgaeProduction", "Macroalgae Production", 0, width = 200),
        numericInput("temp", "Temperature", 0, width = 200),
        numericInput("meanWSpeed", "Mean Wind Speed", 0, width = 200)
      )
    )
  )
)