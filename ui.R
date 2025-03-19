# Elegant and Minimal UI for Great Barrier Reef Aragonite Analysis Application

# Load required packages
library(shiny)
library(remotes)
library(fullPage)
library(leaflet)

# Define an elegant color palette
colors <- list(
  primary = "#1a73e8",      # Blue
  secondary = "#34a853",    # Green
  accent = "#f8bd49",       # Amber
  light = "#f8f9fa",        # Light gray
  white = "#ffffff",        # White
  text = "#202124",         # Dark gray
  textLight = "#5f6368"     # Medium gray
)

# Custom CSS for elegant styling
customCSS <- tags$head(
  tags$style(HTML("
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&family=Montserrat:wght@400;500;700&display=swap');
    
    body, p, input, select, button {
      font-family: 'Poppins', sans-serif;
      font-size: 16px;
    }
    
    h1, h2, h3, h4, h5, h6 {
      font-family: 'Montserrat', sans-serif;
    }
    
    p {
      font-size: 16px;
      line-height: 1.6;
    }
    
    .main-title {
      font-size: 64px;
      font-weight: 700;
      color: white;
      text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
    }
    
    .subtitle {
      font-size: 32px;
      font-weight: 400;
      color: white;
      text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
      margin-top: 20px;
    }
    
    .section-title {
      font-size: 42px;
      font-weight: 700;
      color: #1a73e8;
      margin-bottom: 30px;
      border-bottom: 3px solid #1a73e8;
      padding-bottom: 10px;
      display: inline-block;
    }
    
    .subsection-title {
      font-size: 28px;
      font-weight: 600;
      color: #34a853;
      margin: 30px 0 20px 0;
    }
    
    .panel-title {
      font-size: 18px;
      font-weight: 500;
      color: #1a73e8;
      margin-top: 0;
      margin-bottom: 15px;
    }
    
    .variable-name {
      font-family: 'Roboto Mono', monospace;
      color: #1a73e8;
      font-weight: 500;
      margin: 5px 0;
    }
    
    .control-panel {
      background-color: white;
      padding: 18px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      border-top: 3px solid #1a73e8;
    }
    
    .btn-primary {
      background-color: #1a73e8;
      border-color: #1a73e8;
      color: white;
      border-radius: 4px;
      transition: all 0.3s ease;
    }
    
    .btn-primary:hover {
      background-color: #0d62d1;
      border-color: #0d62d1;
    }
    
    .btn-success {
      background-color: #34a853;
      border-color: #34a853;
    }
    
    .btn-success:hover {
      background-color: #2d9347;
      border-color: #2d9347;
    }
    
    .info-box {
      background-color: #f8f9fa;
      border-left: 4px solid #1a73e8;
      padding: 15px;
      margin: 20px 0;
      border-radius: 4px;
    }
    
    #reefmap {
      height: calc(100vh - 100px) !important;
      width: 100% !important;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
      z-index: 1;
    }
    
    .leaflet-container {
      background: #f8f9fa !important;
    }
    
    hr {
      margin: 15px 0;
      border-top: 1px solid #e8eaed;
    }
    
    .credits-text {
      font-size: 14px;
      color: #5f6368;
      line-height: 1.6;
    }
    
    .team-member {
      display: inline-block;
      margin-right: 8px;
      margin-bottom: 8px;
      padding: 5px 10px;
      background-color: #f1f3f4;
      border-radius: 15px;
      color: #5f6368;
      font-size: 14px;
    }
    
    .aragonite-high {
      font-size: 24px;
      font-weight: 600;
      color: #34a853;
    }
    
    .aragonite-medium {
      font-size: 24px;
      font-weight: 600;
      color: #f8bd49;
    }
    
    .aragonite-low {
      font-size: 24px;
      font-weight: 600;
      color: #ea4335;
    }
  "))
)

# Section colors for fullPage layout
options <- list(
  sectionsColor = c(
    "#1a73e8",  # Welcome - Primary blue
    "#ffffff",  # About - White
    "#f8f9fa",  # Data - Light gray
    "#ffffff",  # Map - White
    "#f8f9fa"   # Credits - Light gray
  ),
  navigation = TRUE,
  navigationPosition = "right"
)

ui <- tagList(
  customCSS,
  
  fullPage(
    center = TRUE,
    opts = options,
    menu = c(
      "Welcome" = "intro",
      "About" = "about",
      "Data" = "data",
      "Risk Calculator" = "map",
      "Credits" = "credits"
    ),
    
    # Welcome section with full-screen background image
    fullSectionImage(
      menu = "intro",
      img = paste0(
        "https://images.unsplash.com/photo-1439405326854-014607f694d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=3540&q=80"),
      div(
        style = "text-align: center; background-color: rgba(0,0,0,0.4); padding: 40px; border-radius: 8px; max-width: 800px; margin: 0 auto;",
        h1("Conservation Project", class = "main-title"),
        h2("Marine and Data Science", class = "subtitle")
      )
    ),
    
    # About section - elegant and minimal
    fullSection(
      menu = "about",
      fullContainer(
        div(
          style = "max-width: 1000px; margin: 0 auto; padding: 40px;",
          h1("About the Project", class = "section-title"),
          
          div(
            class = "info-box",
            h3("Purpose", style = "color: #1a73e8; margin-top: 0;"),
            p("Our data project aims to contribute to the conservation efforts of coral reefs by leveraging advanced machine learning techniques to predict aragonite levels. Collaborating with marine science students, we combine their theoretical knowledge of aragonite with our expertise in data analysis and modeling. This interdisciplinary approach allows us to address the challenges faced by these delicate ecosystems from a data-driven standpoint.",
              style = "line-height: 1.6;")
          ),
          
          p("Our project focuses on predicting the aragonite levels in coral reefs using a combination of two datasets. Aragonite, a critical component of coral reef structures, has a profound impact on reef accretion and erosion processes. By accurately predicting aragonite levels, we can gain valuable insights into the potential for reef growth or degradation in different areas, aiding in effective conservation planning.",
            style = "line-height: 1.6;"),
          
          div(
            style = "display: flex; flex-wrap: wrap; justify-content: space-between; margin-top: 40px;",
            div(
              style = "flex-basis: 30%; min-width: 250px; margin-bottom: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
              h3("Client", class = "subsection-title"),
              p("Great Barrier Marine Park Authority", style = "line-height: 1.6;")
            ),
            div(
              style = "flex-basis: 30%; min-width: 250px; margin-bottom: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
              h3("Product", class = "subsection-title"),
              p("A risk calculator for determining whether the classifications of coral zoning areas require adjustment", style = "line-height: 1.6;")
            ),
            div(
              style = "flex-basis: 30%; min-width: 250px; margin-bottom: 30px; padding: 20px; background-color: #f8f9fa; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);",
              h3("Impact", class = "subsection-title"),
              p("Better informed conservation decisions and more efficient resource allocation for reef protection", style = "line-height: 1.6;")
            )
          )
        )
      )
    ),
    
    # Data section - elegant and minimal
    fullSection(
      menu = "data",
      fullContainer(
        div(
          style = "max-width: 1000px; margin: 0 auto; padding: 40px;",
          h1("Data & Model", class = "section-title"),
          
          div(
            style = "margin-bottom: 40px;",
            h2("Description", class = "subsection-title"),
            p("The data combines environmental measurements from the eReefs project monitoring the Great Barrier Reef. Data includes biogeochemical and hydrodynamic parameters collected from 2015 to 2019.", 
              style = "line-height: 1.6; margin-bottom: 20px;"),
            
            h2("Linear Model", class = "subsection-title"),
            p("Our linear regression model achieves an R-squared value of 95.3%, providing excellent prediction accuracy for aragonite levels based on environmental parameters.",
              style = "line-height: 1.6;")
          ),
          
          div(
            style = "display: flex; flex-wrap: wrap; justify-content: space-between; margin-top: 30px;",
            div(
              style = "flex-basis: 48%; min-width: 300px;",
              h3("Key Variables", class = "subsection-title"),
              div(
                style = "display: grid; grid-template-columns: auto 1fr; gap: 10px 20px; align-items: start;",
                p("aragonite", class = "variable-name"), 
                p("Levels of aragonite measured.", style = "margin: 5px 0; line-height: 1.6;"),
                
                p("latitude", class = "variable-name"), 
                p("Latitude value recorded.", style = "margin: 5px 0; line-height: 1.6;"),
                
                p("longitude", class = "variable-name"), 
                p("Longitude value recorded.", style = "margin: 5px 0; line-height: 1.6;"),
                
                p("temp", class = "variable-name"), 
                p("Temperature level recorded in degrees celsius.", style = "margin: 5px 0; line-height: 1.6;")
              )
            ),
            div(
              style = "flex-basis: 48%; min-width: 300px;",
              h3("\u00A0", style = "visibility: hidden;"), # Invisible heading for alignment
              div(
                style = "display: grid; grid-template-columns: auto 1fr; gap: 10px 20px; align-items: start;",
                p("finesed", class = "variable-name"), 
                p("Levels of fine sediment recorded at the site.", style = "margin: 5px 0; line-height: 1.6;"),
                
                p("salinity", class = "variable-name"), 
                p("Level of salinity recorded in grams per litre.", style = "margin: 5px 0; line-height: 1.6;"),
                
                p("macroalgae", class = "variable-name"), 
                p("Levels of macroalgae production.", style = "margin: 5px 0; line-height: 1.6;"),
                
                p("mean_wspeed", class = "variable-name"), 
                p("Average wind speed.", style = "margin: 5px 0; line-height: 1.6;")
              )
            )
          ),
          
          div(
            style = "background-color: #f8f9fa; border-left: 4px solid #1a73e8; padding: 20px; margin-top: 30px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.1);",
            h2("Risk Levels", style = "color: #1a73e8; margin-top: 0; font-size: 28px; margin-bottom: 15px;"),
            div(
              style = "display: flex; flex-direction: column; gap: 15px;",
              div(
                style = "display: flex; align-items: center; gap: 15px;",
                div(style = "width: 20px; height: 20px; border-radius: 50%; background-color: #34a853;"),
                span("High (≥ 3)", style = "font-size: 20px; font-weight: 600; color: #34a853;"),
                span("Favorable conditions for reef growth", style = "font-size: 18px;")
              ),
              div(
                style = "display: flex; align-items: center; gap: 15px;",
                div(style = "width: 20px; height: 20px; border-radius: 50%; background-color: #f8bd49;"),
                span("Medium (1-3)", style = "font-size: 20px; font-weight: 600; color: #f8bd49;"),
                span("Potential stress conditions", style = "font-size: 18px;")
              ),
              div(
                style = "display: flex; align-items: center; gap: 15px;",
                div(style = "width: 20px; height: 20px; border-radius: 50%; background-color: #ea4335;"),
                span("Low (< 1)", style = "font-size: 20px; font-weight: 600; color: #ea4335;"),
                span("High risk conditions for reef health", style = "font-size: 18px;")
              )
            )
          )
        )
      )
    ),
    
    # Map section - elegant and minimal with focus on the map
    fullSection(
      menu = "map",
      center = FALSE,
      fullContainer(
        div(
          style = "padding: 20px;",
          h1("Aragonite Risk Calculator", class = "section-title", style = "text-align: center; margin-bottom: 20px;"),
          
          # Map container with position relative for absolute panels
          div(
            style = "position: relative; height: calc(100vh - 180px);",
            
            # Main map - take up full container
            leafletOutput("reefmap", width = "100%", height = "100%"),
            
            # Filter panel - elegant and minimal
            absolutePanel(
              top = 10,
              left = 10,
              class = "control-panel",
              style = "width: 220px;",
              
              h2("Filters", class = "panel-title"),
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
                width = "100%"
              ),
              selectInput(
                "showClusters",
                "Clustering",
                c("On" = TRUE,
                  "Off" = FALSE),
                selected = TRUE,
                width = "100%"
              ),
              actionButton("resetFilters", "Reset", class = "btn-primary", style = "width: 100%; margin-top: 10px;")
            ),
            
            # Add point panel - elegant and minimal
            absolutePanel(
              bottom = 10,
              left = 10,
              class = "control-panel",
              style = "width: 220px;",
              
              h2("Add Point", class = "panel-title"),
              p("Click on the map or input coordinates to add a new data point.", style = "font-size: 13px; margin-bottom: 15px; color: #5f6368;"),
              numericInput("add_latitude", "Latitude", 0, width = "100%"),
              numericInput("add_longitude", "Longitude", 0, width = "100%"),
              actionButton("btn_add_point", "Add", class = "btn-primary", style = "width: 100%; margin-top: 10px;")
            ),
            
            # Risk calculator panel - elegant and minimal
            absolutePanel(
              top = 10,
              right = 10,
              class = "control-panel",
              style = "width: 260px;",
              
              h2("Risk Calculator", class = "panel-title"),
              div(
                style = "text-align: center; margin-bottom: 15px;",
                uiOutput("aragonite")
              ),
              hr(),
              
              div(
                style = "margin-bottom: 20px;",
                h3("Location", style = "font-size: 16px; color: #5f6368; margin-bottom: 10px;"),
                div(
                  style = "display: flex; gap: 10px;",
                  div(
                    style = "flex: 1;",
                    numericInput("latitude", "Latitude", 0, width = "100%")
                  ),
                  div(
                    style = "flex: 1;",
                    numericInput("longitude", "Longitude", 0, width = "100%")
                  )
                )
              ),
              
              div(
                style = "margin-bottom: 10px;",
                h3("Environmental Parameters", style = "font-size: 16px; color: #5f6368; margin-bottom: 10px;")
              ),
              
              numericInput("finesed", "Fine Sediment", 0, width = "100%"),
              numericInput("salinity", "Salinity", 0, width = "100%"),
              numericInput("macroalgaeProduction", "Macroalgae Production", 0, width = "100%"),
              numericInput("temp", "Temperature (°C)", 0, width = "100%"),
              numericInput("meanWSpeed", "Mean Wind Speed", 0, width = "100%"),
              
              actionButton("calculateRisk", "Calculate", class = "btn-success", style = "width: 100%; margin-top: 15px;")
            )
          )
        )
      )
    ),
    
    # Credits section - elegant and minimal
    fullSection(
      menu = "credits",
      fullContainer(
        div(
          style = "max-width: 1000px; margin: 0 auto; padding: 40px;",
          h1("Credits & Acknowledgments", class = "section-title"),
          
          div(
            style = "display: flex; flex-wrap: wrap; gap: 30px;",
            div(
              style = "flex: 1; min-width: 300px;",
              h2("Team Members", class = "subsection-title"),
              div(
                style = "margin-top: 15px;",
                span("James Agamemnonos", class = "team-member"),
                span("Adda Ding", class = "team-member"),
                span("Jasmine Glencross", class = "team-member"),
                span("Kade Jansen-Daniel", class = "team-member"),
                span("Shreya Kothari", class = "team-member"),
                span("Shiyuan Li", class = "team-member"),
                span("Hangrui Shi", class = "team-member"),
                span("Simon Um", class = "team-member")
              ),
              
              h2("Data Sources", class = "subsection-title", style = "margin-top: 30px;"),
              p("The data used in this application comes from the eReefs project, which provides comprehensive environmental monitoring of the Great Barrier Reef.",
                class = "credits-text"),
              a("eReefs Website", href = "https://ereefs.org.au/", target = "_blank", 
                style = "color: #1a73e8; text-decoration: none; font-weight: 500;")
            ),
            
            div(
              style = "flex: 1; min-width: 300px;",
              h2("Acknowledgments", class = "subsection-title"),
              p("We would like to thank the Great Barrier Marine Park Authority for their support and guidance throughout this project. We also acknowledge the valuable data provided by the Australian Institute of Marine Science through the eReefs project.",
                class = "credits-text"),
              
              h2("About Aragonite", class = "subsection-title", style = "margin-top: 30px;"),
              p("Aragonite is a form of calcium carbonate that is essential for coral reef formation. The aragonite saturation state is an important indicator of water chemistry conditions that affect coral calcification rates. Healthy reef systems typically require aragonite saturation states above 3.0 for optimal growth.",
                class = "credits-text")
            )
          ),
          
          div(
            style = "margin-top: 50px; text-align: center; color: #5f6368; font-size: 14px;",
            p("© 2023 Great Barrier Reef Conservation Project", style = "margin-bottom: 5px;"),
            p("University of Sydney - DATA3888 Data Science Capstone")
          )
        )
      )
    )
  )
)