Modis_1812<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS_capasHDF/TIF/MCD12Q1.A2018001.h12v12.tif")

AGmap<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/poligonoaguara","Chrysocyon_brachyurus")
plot(AGmap)
proj4string(AGmap)

Modis_1812_proj <- projectRaster(Modis_1812, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")
proj4string(Modis_1812_proj)
plot(Modis_1812_proj)
plot (AGmap, add = TRUE)

unique(getValues(Modis_181_proj))

