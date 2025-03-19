# Coral Data Files

This directory contains NetCDF data files from the eReefs project that are used by the aragonite prediction application. These files contain biogeochemical and hydrodynamic data for the Great Barrier Reef.

## Required Files

The application requires the following NetCDF files:

### Biogeochemical (BGC) Data Files
These files contain key variables like pH, aragonite, temperature, salinity, carbonate, macroalgae production, etc.

```
EREEFS_AIMS-CSIRO_GBR4_H2p0_B3p1_Cq3P_Dhnd_bgc_annual-annual-2015.nc
EREEFS_AIMS-CSIRO_GBR4_H2p0_B3p1_Cq3P_Dhnd_bgc_annual-annual-2016.nc
EREEFS_AIMS-CSIRO_GBR4_H2p0_B3p1_Cq3P_Dhnd_bgc_annual-annual-2017.nc
EREEFS_AIMS-CSIRO_GBR4_H2p0_B3p1_Cq3P_Dhnd_bgc_annual-annual-2018.nc
EREEFS_AIMS-CSIRO_GBR4_H2p0_B3p1_Cq3P_Dhnd_bgc_annual-annual-2019.nc
```

### Hydrodynamic Data Files
These files contain variables like wind speed, currents, etc.

```
EREEFS_AIMS-CSIRO_gbr4_v2_hydro_annual-annual-2015.nc
EREEFS_AIMS-CSIRO_gbr4_v2_hydro_annual-annual-2016.nc
EREEFS_AIMS-CSIRO_gbr4_v2_hydro_annual-annual-2017.nc
EREEFS_AIMS-CSIRO_gbr4_v2_hydro_annual-annual-2018.nc
EREEFS_AIMS-CSIRO_gbr4_v2_hydro_annual-annual-2019.nc
```

## How to Obtain the Files

### BGC Data
1. Visit the AIMS eReefs THREDDS server: https://thredds.ereefs.aims.gov.au/thredds/catalog/ereefs/GBR4_H2p0_B3p1_Cq3P_Dhnd/annual-annual/catalog.html
2. For each year (2015-2019), click on the corresponding file
3. On the file page, look for the "HTTPServer" link to download the NetCDF file
4. Save each file in this directory with the exact filenames listed above

### Hydrodynamic Data
1. Visit the AIMS eReefs THREDDS server: https://thredds.ereefs.aims.gov.au/thredds/catalog/ereefs/gbr4_v2/annual-annual/catalog.html
2. For each year (2015-2019), click on the corresponding file
3. On the file page, look for the "HTTPServer" link to download the NetCDF file
4. Save each file in this directory with the exact filenames listed above

## Data Variables

### BGC Files Include:
- `PH`: pH level
- `CS_bleach`: Coral bleach rate
- `CO32`: Carbonate
- `MA_N_pr`: Macroalgae production
- `omega_ar`: Aragonite saturation
- `temp`: Temperature
- `salt`: Salinity
- `pco2surf`: Oceanic CO₂
- `FineSed`: Fine sediment
- `SG_N_pr`: Seagrass production

### Hydrodynamic Files Include:
- `wspeed_u`: Eastward wind speed
- `wspeed_v`: Northward wind speed
- `mean_wspeed`: Mean wind speed
- `mean_cur`: Mean current speed

## Adding More Recent Data

If you want to extend the application to use more recent data (beyond 2019), download the additional annual files and update the server.R file to include these new data sources. The naming convention for newer files follows the same pattern as the existing files.

## Note About File Size

These NetCDF files are typically large (each can be several GB). Because of their size, they are not included in the GitHub repository and need to be downloaded separately.

If you're having trouble with the file sizes, consider using a subset of the data or contacting AIMS for advice on working with these large datasets.

## Troubleshooting

If you encounter issues reading the NetCDF files:
1. Make sure you have the `ncdf4` package installed
2. Check that the variable names in the files match those expected in the code
3. Verify that the file paths in the server.R file match the actual locations of your downloaded files