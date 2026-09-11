library(raster)


layer1 <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Maxent 2023/C_pl_Bio1.tif")
layer2 <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Variables/rutcamaut.tif")

layer2_resampled <- resample(layer2, layer1, method = "bilinear")

print(layer1)
print(layer2_resampled)

writeRaster(x= layer2_resampled, filename= "Rutas2023", format= "GTiff")
