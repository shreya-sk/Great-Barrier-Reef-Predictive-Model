# Great Barrier Reef Aragonite Prediction

![Great Barrier Reef](https://images.unsplash.com/photo-1439405326854-014607f694d7?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1400&q=80)

## Overview

This interactive Shiny application predicts aragonite levels in the Great Barrier Reef based on environmental parameters. Aragonite, a critical component of coral reef structures, has a profound impact on reef accretion and erosion processes. By accurately predicting aragonite levels, we can gain valuable insights into the potential for reef growth or degradation in different areas, aiding in effective conservation planning.

## Live Demo

View the live application: [Great Barrier Reef Aragonite Analysis]( https://shreya-sk.shinyapps.io/Great-Barrier-Reef-Aragonite/)

## Deployment Information

- Deployed on: shinyapps.io
- Last deployment: March 19, 2025
- Status: [Check status](https://www.shinyapps.io)

## Features

- **Interactive Map**: Visualize aragonite levels across the Great Barrier Reef with color-coded markers
- **Risk Calculator**: Predict aragonite levels based on environmental parameters
- **Filtering Capabilities**: Filter data by year and enable/disable clustering for clearer visualization
- **Add Custom Points**: Add new points to the map to analyze hypothetical scenarios
- **Comprehensive Data Analysis**: Combine biogeochemical and hydrodynamic data for accurate predictions

## Data Sources

The application uses data from the eReefs project, which provides comprehensive environmental monitoring of the Great Barrier Reef. The data includes:

- Biogeochemical parameters: pH, aragonite, temperature, salinity, carbonate, etc.
- Hydrodynamic parameters: wind speed, currents, etc.

Data files are stored in NetCDF format and are processed in the application to provide real-time analysis and visualization.

## Installation and Setup

### Prerequisites

- R (version 4.0.0 or higher)
- The following R packages:
  - shiny
  - remotes
  - fullPage
  - leaflet
  - leaflet.extras
  - dplyr
  - caret
  - hydroGOF
  - e1071
  - sns
  - ggplot2
  - ggfortify
  - tidyverse
  - ncdf4
  - rbenchmark
  - gtools

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/Great-Barrier-Reef_Data-Project.git
   cd Great-Barrier-Reef_Data-Project
   ```

2. Install required packages:
   ```R
   install.packages(c("shiny", "leaflet", "leaflet.extras", "dplyr", "caret", 
                    "hydroGOF", "e1071", "sns", "ggplot2", "ggfortify", 
                    "tidyverse", "ncdf4", "rbenchmark", "gtools", "remotes"))
   remotes::install_github("RinteRface/fullPage")
   ```

3. Download the required NetCDF data files by following the instructions in [Coral_data/README.md](Coral_data/README.md)

### Running the Application

1. Open R or RStudio
2. Set your working directory to the project folder
3. Run the app:
   ```R
   shiny::runApp()
   ```

Alternatively, use the app.R file:
```R
Rscript -e "options(repos = c(CRAN = 'https://cloud.r-project.org/')); shiny::runApp()"
```

## Project Structure

```
Great-Barrier-Reef_Data-Project/
├── ui.R                   # User interface definition
├── server.R               # Server logic
├── app.R                  # Combined app file (optional)
├── Coral_data/            # Directory for NetCDF files
│   ├── README.md          # Instructions for data files
│   └── *.nc               # NetCDF data files
├── www/                   # Static assets (if any)
└── README.md              # This file
```

## How to Use

1. Navigate to the 'Risk Calculator' tab to access the interactive map
2. Filter data by year or enable clustering for clearer visualization
3. Click on any point on the map to load its environmental parameters
4. Adjust parameters manually to explore different scenarios
5. The calculated aragonite value is color-coded to indicate risk level:
   - Green: Healthy aragonite levels (≥ 3)
   - Orange: Moderate risk (1-3)
   - Red: High risk (< 1)

## Extending the Application

To include more recent data:

1. Download additional NetCDF files from the eReefs project
2. Place them in the Coral_data directory
3. Update the file paths in server.R to include the new files
4. Update the year dropdown in ui.R to include new options

## Contributors

- James Agamemnonos
- Adda Ding
- Jasmine Glencross
- Kade Jansen-Daniel
- Shreya Kothari
- Shiyuan Li
- Hangrui Shi
- Simon Um

## Acknowledgements

We would like to thank the Great Barrier Marine Park Authority for their support and guidance throughout this project. We also acknowledge the valuable data provided by the Australian Institute of Marine Science through the eReefs project.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
