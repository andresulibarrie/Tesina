#uso de suelo - pastizales - año 2018 sector 12
Modis_1812<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/TIF/MCD12Q1.A2018001.h12v12.tif")

AGmap<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/poligonoaguara","Chrysocyon_brachyurus")
plot(AGmap)
proj4string(AGmap)

Modis_1812_proj <- projectRaster(Modis_1812, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")
proj4string(Modis_1812_proj)
plot(Modis_1812_proj)
plot (AGmap, add = TRUE)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") 
projection(AGmap) <- crs.geo


unique(getValues(Modis_1812_proj))
Modis_1812_proj_crop <- crop(Modis_1812_proj, AGmap)
plot(Modis_1812_proj_crop)
Modis_1812_proj_crop_mask <- mask(Modis_1812_proj_crop, AGmap)
plot(Modis_1812_proj_crop_mask )
getValues(Modis_1812_proj_crop_mask)
class(getValues(Modis_1812_proj_crop_mask))

Pastizal <- Modis_1812_proj_crop_mask
Pastizal [Pastizal > 10] <- NA
Pastizal [Pastizal < 10] <- NA
plot(Pastizal)
writeRaster(x= Pastizal, filename= "Pastizal_1812", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))

#al haber cargado ya todos los mapas de modis en el archivo usodesuelo-cultivo solo hago recategorizacion

Pastizal <- Modis_1811_proj_crop_mask
Pastizal [Pastizal > 10] <- NA
Pastizal [Pastizal < 10] <- NA
plot(Pastizal)
writeRaster(x= Pastizal, filename= "Pastizal_1811", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))

Pastizal <- Modis_0112_proj_crop_mask
Pastizal [Pastizal > 10] <- NA
Pastizal [Pastizal < 10] <- NA
plot(Pastizal)
writeRaster(x= Pastizal, filename= "Pastizal_0112", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))

Pastizal <- Modis_0111_proj_crop_mask
Pastizal [Pastizal > 10] <- NA
Pastizal [Pastizal < 10] <- NA
plot(Pastizal)
writeRaster(x= Pastizal, filename= "Pastizal_0111", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))

#para 2005

Modis_0512<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/TIF/MCD12Q1.A2005001.h12v12.tif")

AGmap<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/poligonoaguara","Chrysocyon_brachyurus")
plot(AGmap)
proj4string(AGmap)

Modis_0512_proj <- projectRaster(Modis_0512, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")
proj4string(Modis_0512_proj)
plot(Modis_0512_proj)
plot (AGmap, add = TRUE)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") 
projection(AGmap) <- crs.geo


unique(getValues(Modis_0512_proj))
Modis_0512_proj_crop <- crop(Modis_0512_proj, AGmap)
plot(Modis_0512_proj_crop)
Modis_0512_proj_crop_mask <- mask(Modis_0512_proj_crop, AGmap)
plot(Modis_0512_proj_crop_mask )

Pastizal <- Modis_0512_proj_crop_mask
Pastizal [Pastizal > 10] <- NA
Pastizal [Pastizal < 10] <- NA
plot(Pastizal)
writeRaster(x= Pastizal, filename= "Pastizal_0512", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))



Modis_0511<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/TIF/MCD12Q1.A2005001.h12v11.tif")

Modis_0511_proj <- projectRaster(Modis_0511, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")
proj4string(Modis_0511_proj)
plot(Modis_0511_proj)
plot (AGmap, add = TRUE)

unique(getValues(Modis_0511_proj))
Modis_0511_proj_crop <- crop(Modis_0511_proj, AGmap)
plot(Modis_0511_proj_crop)
Modis_0511_proj_crop_mask <- mask(Modis_0511_proj_crop, AGmap)
plot(Modis_0511_proj_crop_mask )

Pastizal <- Modis_0511_proj_crop_mask
Pastizal [Pastizal > 10] <- NA
Pastizal [Pastizal < 10] <- NA
plot(Pastizal)
writeRaster(x= Pastizal, filename= "Pastizal_0511", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))

