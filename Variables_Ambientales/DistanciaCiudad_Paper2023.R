x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", 
       "sp","ncdf4","dismo","terra","landscapemetrics")
lapply(x, library, character.only = TRUE)

#Ciudades 2018----

Landuse18 <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS/LandCover_Type_Yearly_500m_v6/LC1/MCD12Q1_LC1_2018_001.tif")
plot(Landuse18)

sta_fe_P<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/SantaFe_plano", "Sta_fe_plano")
sta_fe_P
plot(sta_fe_P)

proj4string(sta_fe_P)
proj4string(Landuse18)

Landuse18_prj <- projectRaster(Landuse18, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs",method = "ngb") 
#se le agrega ngb xq al ser variables categoricas no nos sirve la que es por defecto (un promedio de los dos tipos de clases) sino que necesitamos una sola categoria (un nro entero) con este metodo por lo tanto se selecciona una caterogira (la que predomina)

proj4string(sta_fe_P)
proj4string(Landuse18_prj)
extent(sta_fe_P)
extent(Landuse18_prj)

plot(Landuse18_prj)
plot (sta_fe_P, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe_P)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe_P)
plot(Landuse18_prj_crop_mask)
getValues(Landuse18_prj_crop_mask)
class(getValues(Landuse18_prj_crop_mask))

Ciudad<- Landuse18_prj_crop_mask
Ciudad [Ciudad< 13] <- NA
Ciudad [Ciudad > 13] <- NA
plot (Ciudad)
extent(Ciudad)

writeRaster(x= Ciudad, filename= "Ciudad18P2", format= "GTiff", bylayer= TRUE, suffix=names(Ciudad))

Ciudad18P <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Ciudades/Ciudad18P2.tif")
plot(Ciudad18P)
extent(Ciudad18P)

distCd <- distance(Ciudad18P)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_P)
distCd_crop_mask <- mask(distCd_crop, sta_fe_P)
plot(distCd_crop_mask)
extent(c)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades18P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))

#Ciudades 2013----
Landuse13 <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS/LandCover_Type_Yearly_500m_v6/LC1/MCD12Q1_LC1_2013_001.tif")
plot(Landuse18)

sta_fe_P<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/SantaFe_plano", "Sta_fe_plano")
sta_fe_P
plot(sta_fe_P)

proj4string(sta_fe_P)
proj4string(Landuse13)

Landuse13_prj <- projectRaster(Landuse13, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs",method = "ngb") #se le agrega ngb xq al ser variables categoricas no nos sirve la que es por defecto (un promedio de los dos tipos de clases) sino que necesitamos una sola categoria (un nro entero) con este metodo por lo tanto se selecciona una caterogira (la que predomina)

proj4string(sta_fe_P)
proj4string(Landuse13_prj)
extent(sta_fe_P)
extent(Landuse13_prj)

plot(Landuse13_prj)
plot (sta_fe_P, add = TRUE)

Landuse13_prj_crop <- crop(Landuse13_prj, sta_fe_P)
Landuse13_prj_crop_mask <- mask(Landuse13_prj_crop, sta_fe_P)
plot(Landuse13_prj_crop_mask)
getValues(Landuse13_prj_crop_mask)
class(getValues(Landuse13_prj_crop_mask))

Ciudad<- Landuse13_prj_crop_mask
Ciudad [Ciudad< 13] <- NA
Ciudad [Ciudad > 13] <- NA
plot (Ciudad)

writeRaster(x= Ciudad, filename= "Ciudad13P", format= "GTiff", bylayer= TRUE, suffix=names(Ciudad))

Ciudad13P <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Cultivos13P.tif")

distCd <- distance(Ciudad13P)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_P)
distCd_crop_mask <- mask(distCd_crop, sta_fe_P)
plot(distCd_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades13P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))

#Ciudades 2008----
#Ciudad<- Landuse8_prj_crop_mask
#Ciudad [Ciudad< 13] <- NA
#Ciudad [Ciudad > 13] <- NA
#plot (Ciudad)
plot(Ciudad8)
writeRaster(x= Ciudad8, filename= "Ciudad08P", format= "GTiff", bylayer= TRUE, suffix=names(Ciudad8))

Ciudad08P <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Ciudad08P.tif")

distCd <- distance(Ciudad08P)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_P)
distCd_crop_mask <- mask(distCd_crop, sta_fe_P)
plot(distCd_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades08P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))

#Ciudades 2003----
#Ciudad<- Landuse3_prj_crop_mask
#Ciudad [Ciudad< 13] <- NA
#Ciudad [Ciudad > 13] <- NA
#plot (Ciudad)

writeRaster(x= Ciudad3, filename= "Ciudad03P", format= "GTiff", bylayer= TRUE, suffix=names(Ciudad3))
Ciudad03P<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Ciudad03P.tif")

distCd <- distance(Ciudad03P)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_P)
distCd_crop_mask <- mask(distCd_crop, sta_fe_P)
plot(distCd_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades03P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))



#Ciudades prom----

CiudadProm <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Ciudades/Ciudades_Prom.tif")
extent(CiudadProm)
plot(CiudadProm)

distCiudad <- distance(CiudadProm)
plot(distCiudad)
extent(distCiudad)

distCdProm <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/distCiudadesProm.tif")
plot(distCdProm)
extent(distCdProm)

molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs")

print(distCdProm)
print(molde_rtr)
print(rutas)

layer2_resampled <- resample(distCdProm, molde_rtr, method = "bilinear")

print(molde_rtr)
print(layer2_resampled)
plot(layer2_resampled)


ModisUS <- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años"
setwd(ModisUS)

writeRaster(x= layer2_resampled, filename= "DistCiudadFINAL", format= "GTiff", bylayer= TRUE, suffix=names(layer2_resampled))


