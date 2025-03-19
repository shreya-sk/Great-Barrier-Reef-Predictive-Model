# Great Barrier Reef Trichodesmium Analysis

## Overview
This Shiny application analyzes environmental factors affecting Trichodesmium blooms in the Great Barrier Reef. The app identifies optimal marine stations that accommodate suitable weather conditions and salinity levels to support the presence of Trichodesmium, an important cyanobacterium in the global nitrogen cycle.

![Trichodesmium Bloom](https://cff2.earth.com/uploads/2019/09/15190611/capricorn_oli_2019244_lrg-1400x850.jpg)

## About Trichodesmium
Trichodesmium is a marine cyanobacterium that:
- Plays a crucial role in the global nitrogen cycle
- Contributes significantly to the input of atmospheric nitrogen into the ocean
- Requires specific environmental conditions to bloom
- Is affected primarily by temperature and salinity levels

## Data
The data used in this application was obtained from the Australian Institute of Marine Science (AIMS) and includes measurements from various stations across the Great Barrier Reef from 1992 to 2009.

## Key Findings
- **Optimal Months**: Trichodesmium blooms are most likely in March, May, and October
- **Temperature Range**: Optimal temperatures range from approximately 25°C to 29°C
- **Salinity Range**: Optimal salinity levels range from 35.6 psu to 38 psu
- **Recommended Stations**:
  1. John Brewer Reef
  2. Townsville Shipping Channel
  3. Woongarra Burkitts Reef
  4. QSS1

## Features
- Interactive visualizations of Trichodesmium presence based on:
  - Season/Month
  - Temperature
  - Salinity
- Station filtering based on optimal conditions
- Statistical analysis of environmental factors

## Installation

### Prerequisites
- R (version 4.0 or higher recommended)
- RStudio (for easier Shiny app development)

### Required R Packages
```R
# Install required packages
install.packages(c(
  "shiny",
  "shinydashboard",
  "ggplot2",
  "dplyr",
  "lubridate",
  "tidyverse",
  "viridis",
  "DT",
  "plotly",
  "hrbrthemes",
  "formattable"
))
```

### Running the App
1. Clone this repository
```bash
git clone https://github.com/yourusername/Great-Barrier-Reef_Data-Project.git
cd Great-Barrier-Reef_Data-Project
```

2. Launch the app in RStudio by opening the `app.R` file and clicking "Run App", or run:
```R
shiny::runApp()
```

## Screenshots
*[Add screenshots of your Shiny app here]*

## Contributors
- [Your Name] - Data Science & Marine Science collaboration

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements
- Great Barrier Reef Marine Park Authority (GBRMPA)
- Australian Maritime Safety Authority (AMSA)
- Australian Institute of Marine Science (AIMS) for providing the dataset
