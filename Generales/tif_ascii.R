library(spatial.tools)

plot(Rios_prj)
plot(rutas_prj)
plot(rutcamaut_sptr)

rutas_tif <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/RutasLong_tif.tif")
rutcamaut_tif <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/RutcamautLong_tif.tif")
rios_tif <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/RiosLong_tif.tif")
pastizal<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/ProporcionPastizalF.tif")
cultivo<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/ProporcionCultivos13-11SF.tif")
Bio1<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/C_pl_Bio1.tif")
Bio9<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/C_pl_Bio9.tif")
ciudad <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/ciudad_sync.tif")
lagperm<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/lagperm_sync.tif")
extent(rutas_tif)
extent(rutcamaut_tif)
extent(rios_tif)
extent(pastizal)
extent(cultivo)
extent(Bio1)
extent(Bio9)
extent(ciudad)
extent(lagperm)
plot(ciudad)
plot(lagperm)

plot(rios_tif)
plot(rutcamaut_tif)
plot(rutas_tif)

Bios = list.files(vardir,pattern = 'Bio', full.names = TRUE)
Bios

Bios_stack <- stack(Bios)
proj4string(Bios_stack)
Bios_stack <- projectRaster(Bios_stack, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb")

writeRaster(x= Bios_stack, filename= "C_pl", format= "GTiff",bylayer = TRUE, suffix= names(Bios_stack))

syncCB1<- spatial_sync_raster(ciudad, Bio1, method = "ngb")
#spatial_sync_raster(ciudad, Bio1, method = "bilinear")
writeRaster(x= syncCB1, filename= "ciudad_sync", format= "GTiff", bylayer= TRUE, suffix=names(syncCB1))

syncLB1<- spatial_sync_raster(lagperm, Bio1, method = "ngb")
extent(syncLB1)
writeRaster(x= syncLB1, filename= "lagperm_sync", format= "GTiff", bylayer= TRUE, suffix=names(syncLB1))




windows()
plot(lagperm_sync)
plot(lagperm)
extent(lagperm_sync)
extent(syncLB1)
?projectRaster()
Bio1_res<- projectRaster(Bio1, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb",res = 4295)
plot(Bio1_res)
writeRaster(x= Bio1_res, filename= "bio1_ascii", format= "ascii")

rutas_tif
rios_tif
rutcamaut_tif

sta_fe<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
sta_fe
plot(sta_fe_sptr)
sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

rutas_tif_mask <- mask(rutas_tif, sta_fe_sptr)
plot(rutas_tif_mask)
rios_tif_mask <- mask(rios_tif, sta_fe_sptr)
plot(rios_tif_mask)
rutcamaut_tif_mask <- mask(rutcamaut_tif, sta_fe_sptr)
plot(rutcamaut_tif_mask)

writeRaster(x= rutas_tif_mask, filename= "rutas", format= "GTiff")
writeRaster(x= rios_tif_mask, filename= "rios", format= "GTiff")
writeRaster(x= rutcamaut_tif_mask, filename= "rutcamaut", format= "GTiff")

vardir<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Variables"
setwd(vardir)
getwd()
files <- list.files(vardir,pattern = '.tif', full.names = TRUE)
var<-stack(files) 

names(var)
var_res<- projectRaster(var, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb",res = 4295)

writeRaster(x= var_res, filename= "ascii", format= "ascii", bylayer= TRUE, suffix=names(var_res))


            