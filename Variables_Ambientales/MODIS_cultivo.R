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

Cultivo <- Modis_1812_proj_crop_mask
Cultivo [Cultivo < 12] <- NA
Cultivo [Cultivo > 14] <- NA
Cultivo [Cultivo == 13] <- NA

Cultivo [Cultivo == 12] <- 14
plot(Cultivo)

writeRaster(x= Cultivo, filename= "Cultivos_1812", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo))

#uso de suelo: año 2018 sector 11
Modis_1811<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/TIF/MCD12Q1.A2018001.h12v11.tif")
Modis_1811_proj <- projectRaster(Modis_1811, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")
proj4string(Modis_1811_proj)
plot(Modis_1811_proj)
plot (AGmap, add = TRUE)

unique(getValues(Modis_1811_proj))
Modis_1811_proj_crop <- crop(Modis_1811_proj, AGmap)
plot(Modis_1811_proj_crop)
Modis_1811_proj_crop_mask <- mask(Modis_1811_proj_crop, AGmap)
plot(Modis_1811_proj_crop_mask )

Cultivo <- Modis_1811_proj_crop_mask
Cultivo [Cultivo < 12] <- NA
Cultivo [Cultivo > 14] <- NA
Cultivo [Cultivo == 13] <- NA

Cultivo [Cultivo == 12] <- 14
plot(Cultivo)
writeRaster(x= Cultivo, filename= "Cultivos_1811", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo))

#uso de suelo año 2001 sector 11
Modis_0111<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/TIF/MCD12Q1.A2001001.h12v11.tif")
Modis_0111_proj <- projectRaster(Modis_0111, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")
proj4string(Modis_0111_proj)
plot(Modis_0111_proj)
plot (AGmap, add = TRUE)

unique(getValues(Modis_0111_proj))
Modis_0111_proj_crop <- crop(Modis_0111_proj, AGmap)
plot(Modis_0111_proj_crop)
Modis_0111_proj_crop_mask <- mask(Modis_0111_proj_crop, AGmap)
plot(Modis_0111_proj_crop_mask )

Cultivo <- Modis_0111_proj_crop_mask
Cultivo [Cultivo < 12] <- NA
Cultivo [Cultivo > 14] <- NA
Cultivo [Cultivo == 13] <- NA

Cultivo [Cultivo == 12] <- 14
plot(Cultivo)
writeRaster(x= Cultivo, filename= "Cultivos_0111", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo))

#uso de suelo año 2001 sector 12
Modis_0112<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/TIF/MCD12Q1.A2001001.h12v12.tif")
Modis_0112_proj <- projectRaster(Modis_0112, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")
proj4string(Modis_0112_proj)
plot(Modis_0112_proj)
plot (AGmap, add = TRUE)

unique(getValues(Modis_0112_proj))
Modis_0112_proj_crop <- crop(Modis_0112_proj, AGmap)
plot(Modis_0112_proj_crop)
Modis_0112_proj_crop_mask <- mask(Modis_0112_proj_crop, AGmap)
plot(Modis_0112_proj_crop_mask )

Cultivo <- Modis_0112_proj_crop_mask
Cultivo [Cultivo < 12] <- NA
Cultivo [Cultivo > 14] <- NA
Cultivo [Cultivo == 13] <- NA

Cultivo [Cultivo == 12] <- 14
plot(Cultivo)
writeRaster(x= Cultivo, filename= "Cultivos_0112", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo))
