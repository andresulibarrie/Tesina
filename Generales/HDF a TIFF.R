install.packages("gdalUtils")
library(gdalUtils)
# Get a list of sds names
sds <- get_subdatasets("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/MCD12Q1.A2018001.h12v12.006.2019199203127.hdf")
# Isolate the name of the first sds
UsoSuelo18_12 <- sds[1]
filetif <- "HDFMCD12Q1.A2018001.h12v12.tif"
gdal_translate(sds[1], dst_dataset = filetif)
# Load the Geotiff created into R
r <- raster(filetif)
proj4string(r)
plot(r)

sds2 <- get_subdatasets("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/MCD12Q1.A2018001.h12v11.006.2019199203317.hdf")
UsoSuelo18_11 <- sds2[1]
filetif2 <- "MCD12Q1.A2018001.h12v11.tif"
gdal_translate(sds2[1], dst_dataset = filetif2)
r2 <- raster(filetif2)

sds3 <- get_subdatasets("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/MCD12Q1.A2001001.h12v11.006.2018142183858.hdf")
UsoSuelo01_11_01 <- sds3[1]
filetif3 <- "MCD12Q1.A2001001.h12v11.tif"
gdal_translate(sds3[1], dst_dataset = filetif3)
r3 <- raster(filetif3)

sds4 <- get_subdatasets("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/MCD12Q1.A2001001.h12v12.006.2018142183909.hdf")
UsoSuelo01_12_01 <- sds4[1]
filetif4 <- "MCD12Q1.A2001001.h12v12.tif"
gdal_translate(sds4[1], dst_dataset = filetif4)
r4 <- raster(filetif4)

plot(UsoSuelo01_11_01)
plot(r2)
plot(r3)
plot(r4)

sds5 <- get_subdatasets("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/MCD12Q1.A2005001.h12v11.006.2018145164505.hdf")
# Isolate the name of the first sds
UsoSuelo05_11 <- sds5[1]
filetif5 <- "MCD12Q1.A2005001.h12v11.tif"
gdal_translate(sds5[1], dst_dataset = filetif5)
# Load the Geotiff created into R
r5 <- raster(filetif5)
proj4string(r5)
plot(r5)

sds6 <- get_subdatasets("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/MCD12Q1.A2005001.h12v12.006.2018145164532.hdf")
# Isolate the name of the first sds
UsoSuelo05_12 <- sds6[1]
filetif6 <- "MCD12Q1.A2005001.h12v12.tif"
gdal_translate(sds6[1], dst_dataset = filetif6)
# Load the Geotiff created into R
r6 <- raster(filetif6)
proj4string(r6)
plot(r6)
