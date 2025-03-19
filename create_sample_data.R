# create_sample_data.R
# Create a sample dataset from NetCDF files for easier deployment

# Load necessary libraries
library(ncdf4)
library(dplyr)

# Check if Coral_data directory exists
if (!dir.exists("Coral_data")) {
  stop("Coral_data directory not found. Please run this script from the project root directory.")
}

# Function to extract a sample from an NC file
extract_sample_from_nc <- function(bgc_file, hydro_file, year) {
  tryCatch({
    # Open the BGC file
    bgc_nc <- nc_open(bgc_file)
    
    # Get dimensions
    lat <- ncvar_get(bgc_nc, "latitude")
    lon <- ncvar_get(bgc_nc, "longitude")
    
    # Sample size - take every 10th point
    lat_step <- max(1, floor(length(lat) / 10))
    lon_step <- max(1, floor(length(lon) / 10))
    
    lat_sample <- lat[seq(1, length(lat), by = lat_step)]
    lon_sample <- lon[seq(1, length(lon), by = lon_step)]
    
    # Create grid of coordinates
    lonlat_grid <- expand.grid(longitude = lon_sample, latitude = lat_sample)
    
    # Extract variables
    temp <- ncvar_get(bgc_nc, "temp")
    salinity <- ncvar_get(bgc_nc, "salt")
    aragonite <- ncvar_get(bgc_nc, "omega_ar")
    finesed <- ncvar_get(bgc_nc, "FineSed")
    macroalgae <- ncvar_get(bgc_nc, "MA_N_pr")
    
    # Subsample the data
    temp_sample <- matrix(NA, nrow = length(lon_sample), ncol = length(lat_sample))
    salinity_sample <- matrix(NA, nrow = length(lon_sample), ncol = length(lat_sample))
    aragonite_sample <- matrix(NA, nrow = length(lon_sample), ncol = length(lat_sample))
    finesed_sample <- matrix(NA, nrow = length(lon_sample), ncol = length(lat_sample))
    macroalgae_sample <- matrix(NA, nrow = length(lon_sample), ncol = length(lat_sample))
    
    for (i in 1:length(lon_sample)) {
      for (j in 1:length(lat_sample)) {
        lon_idx <- which(lon == lon_sample[i])
        lat_idx <- which(lat == lat_sample[j])
        
        if (length(lon_idx) > 0 && length(lat_idx) > 0) {
          temp_sample[i, j] <- temp[lon_idx[1], lat_idx[1]]
          salinity_sample[i, j] <- salinity[lon_idx[1], lat_idx[1]]
          aragonite_sample[i, j] <- aragonite[lon_idx[1], lat_idx[1]]
          finesed_sample[i, j] <- finesed[lon_idx[1], lat_idx[1]]
          macroalgae_sample[i, j] <- macroalgae[lon_idx[1], lat_idx[1]]
        }
      }
    }
    
    # Close the NC file
    nc_close(bgc_nc)
    
    # Open the hydro file
    hydro_nc <- nc_open(hydro_file)
    
    # Extract wind speed
    mean_wspeed <- ncvar_get(hydro_nc, "mean_wspeed")
    
    # Subsample wind speed
    mean_wspeed_sample <- matrix(NA, nrow = length(lon_sample), ncol = length(lat_sample))
    
    for (i in 1:length(lon_sample)) {
      for (j in 1:length(lat_sample)) {
        lon_idx <- which(lon == lon_sample[i])
        lat_idx <- which(lat == lat_sample[j])
        
        if (length(lon_idx) > 0 && length(lat_idx) > 0) {
          mean_wspeed_sample[i, j] <- mean_wspeed[lon_idx[1], lat_idx[1]]
        }
      }
    }
    
    # Close the NC file
    nc_close(hydro_nc)
    
    # Create data frame
    sample_data <- data.frame(
      longitude = lonlat_grid$longitude,
      latitude = lonlat_grid$latitude,
      temp = as.vector(temp_sample),
      salinity = as.vector(salinity_sample),
      aragonite = as.vector(aragonite_sample),
      finesed = as.vector(finesed_sample),
      macroalgae_production = as.vector(macroalgae_sample),
      mean_wspeed = as.vector(mean_wspeed_sample),
      year = year
    )
    
    # Remove NA rows
    sample_data <- na.omit(sample_data)
    
    return(sample_data)
    
  }, error = function(e) {
    cat("Error processing files for year", year, ":", e$message, "\n")
    return(NULL)
  })
}

# Try to extract samples from each year
years <- 2015:2019
sample_data_list <- list()

for (year in years) {
  bgc_file <- paste0("Coral_data/EREEFS_AIMS-CSIRO_GBR4_H2p0_B3p1_Cq3P_Dhnd_bgc_annual-annual-", year, ".nc")
  hydro_file <- paste0("Coral_data/EREEFS_AIMS-CSIRO_gbr4_v2_hydro_annual-annual-", year, ".nc")
  
  if (file.exists(bgc_file) && file.exists(hydro_file)) {
    cat("Processing files for year", year, "...\n")
    year_sample <- extract_sample_from_nc(bgc_file, hydro_file, year)
    
    if (!is.null(year_sample)) {
      sample_data_list[[as.character(year)]] <- year_sample
      cat("Successfully processed year", year, "\n")
    }
  } else {
    cat("Files for year", year, "not found\n")
  }
}

# If we have data for at least one year
if (length(sample_data_list) > 0) {
  # Combine all years
  all_sample_data <- do.call(rbind, sample_data_list)
  
  # Calculate aragonite using the formula
  calculate_aragonite <- function(finesed, salinity, macroalgaeProduction, temp, meanWSpeed, latitude, longitude){
    aragonite = 6.826e+00 + (finesed * -1.844e+05) + 
      (salinity * -8.612e-02) + 
      (macroalgaeProduction * -5.998e+00) + 
      (temp * 1.637e-02) + 
      (meanWSpeed * -1.355e-02) + 
      (latitude * 5.464e-03) + 
      (longitude * -2.921e-03)
    return(aragonite)
  }
  
  # Recalculate aragonite to ensure consistency
  all_sample_data$aragonite <- calculate_aragonite(
    all_sample_data$finesed,
    all_sample_data$salinity,
    all_sample_data$macroalgae_production,
    all_sample_data$temp,
    all_sample_data$mean_wspeed,
    all_sample_data$latitude,
    all_sample_data$longitude
  )
  
  # Save as RDS
  saveRDS(all_sample_data, "sample_data.rds")
  cat("Sample data saved to sample_data.rds\n")
  cat("Number of data points:", nrow(all_sample_data), "\n")
} else {
  # Create mock data if no real data is available
  cat("No real data could be processed. Creating mock data...\n")
  
  # Create grid of coordinates covering the Great Barrier Reef area
  latitudes <- seq(-19, -16, by = 0.1)
  longitudes <- seq(145, 147, by = 0.1)
  grid <- expand.grid(longitude = longitudes, latitude = latitudes)
  
  # Number of years
  years <- 2015:2019
  
  # Create a data frame with all combinations of coordinates and years
  mock_data_list <- list()
  
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
    mock_data_list[[as.character(year)]] <- year_data
  }
  
  # Combine all years
  all_mock_data <- do.call(rbind, mock_data_list)
  
  # Save as RDS
  saveRDS(all_mock_data, "sample_data.rds")
  cat("Mock data saved to sample_data.rds\n")
  cat("Number of data points:", nrow(all_mock_data), "\n")
}