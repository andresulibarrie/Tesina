x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages('raster')

lapply(x, library, character.only = TRUE)

path<- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Bosques"
setwd(path)
getwd()

#Para Bosques----
files = list.files(path,pattern = '*.tif', full.names = TRUE)
class(files)
Bosques_stack <- stack(files)
class(Bosques_stack)

Bosques_stack_prom <- calc(Bosques_stack,mean)
Bosques_stack_prom
plot(Bosques_stack_prom)
writeRaster(x= Bosques_stack_prom, filename= "Bosques_Prom", format= "GTiff")

#Para Pastizales----
path<- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Pastizales"
setwd(path)

files = list.files(path,pattern = '*.tif', full.names = TRUE)
class(files)
Pastizales_stack <- stack(files)
class(Pastizales_stack)

Pastizales_stack_prom <- calc(Pastizales_stack,mean)
Pastizales_stack_prom
plot(Pastizales_stack_prom)
writeRaster(x= Pastizales_stack_prom, filename= "Pastizales_Prom", format= "GTiff")

#Para Cultivos----
path<- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Cultivos"
setwd(path)

filesCrop = list.files(path,pattern = '*.tif', full.names = TRUE)
class(filesCrop)
Cultivos_stack <- stack(filesCrop)
class(Cultivos_stack)

Cultivos_stack_prom <- calc(Cultivos_stack,mean)
Cultivos_stack_prom
plot(Cultivos_stack_prom)
writeRaster(x= Cultivos_stack_prom, filename= "Cultivos_Prom", format= "GTiff")

#Para ciudades----
path<- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Ciudades"
setwd(path)

files = list.files(path,pattern = '*.tif', full.names = TRUE)
class(files)
Ciudades_stack <- stack(files)
class(Ciudades_stack)

Ciudades_stack_prom <- calc(Ciudades_stack,mean)
Ciudades_stack_prom
plot(Ciudades_stack_prom)
writeRaster(x= Ciudades_stack_prom, filename= "Ciudades_Prom", format= "GTiff")
