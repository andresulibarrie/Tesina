x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", 
       "sp","ncdf4","dismo","terra","landscapemetrics")
lapply(x, library, character.only = TRUE)

#Ciudades 2018----

sta_fe_P<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/SantaFe_plano", "Sta_fe_plano")
sta_fe_P
plot(sta_fe_P)

rutas <- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/Rutas_stafe_plano","RutasP")

proj4string(sta_fe_P)
proj4string(rutas)

plot(rutas)
plot (sta_fe_P, add = TRUE)

rsf<-raster(sta_fe_P)
rsf
res(rsf) <- 500
rutas_raster <- rasterize(rutas, rsf, field = "TIPO")
plot(rutas_raster)
rutas_raster[rutas_raster==2] <- 1

writeRaster(x= AguasPerm_sptr_raster, filename= "AguasPermSF_raster", format= "GTiff", bylayer= TRUE, suffix=names(AguasPerm_sptr_raster))

AguasPermRaster<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/AguasPermSF.tif")
proj4string(AguasPermRaster)
extent(AguasPermRaster)

distAgPerm <- distance(AguasPermRaster)
plot(distAgPerm)
plot (sta_fe, add = TRUE)

extent(distAgPerm)

distAgPerm_crop <- crop(distAgPerm, sta_fe)
distAgPerm_crop_mask <- mask(distAgPerm_crop, sta_fe_sptr)
plot(distAgPerm_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distAgPerm_crop_mask, filename= "distAgPerm", format= "GTiff", bylayer= TRUE, suffix=names(distAgPerm_crop_mask))

distAgPerm_tiff <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/distAgPerm.tif")
class(distAgPerm_tiff)
#hasta aca----
distRutas <- distance(rutas)
plot(ddistRutas)

distCd_crop <- crop(distCd, sta_fe_P)
distCd_crop_mask <- mask(distCd_crop, sta_fe_P)
plot(distCd_crop_mask)
extent(c)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades18P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))

