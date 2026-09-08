library(raster)
library(rgdal)
library(sf)
library(terra)
library(landscapemetrics)

x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
lapply(x, library, character.only = TRUE)


setwd("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS/LandCover_Type_Yearly_500m_v6/LC1")

#Preparando MODIS----
r_prj <- projectRaster(r, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0")

AGmap<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/poligonoaguara","Chrysocyon_brachyurus")
plot(AGmap)
proj4string(AGmap)

sta_fe<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
plot(sta_fe)
proj4string(sta_fe)
sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(sta_fe_sptr)

arg<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/Argentina", "provincia")
plot(arg)
proj4string(arg)
arg_prj <- spTransform(arg, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(arg_prj)
plot(arg_prj)

#Capa uso de suelo 2013----
Landuse13 <- raster("MCD12Q1_LC1_2013_001.tif")
Landuse13
getValues(Landuse13)
plot(Landuse13)
unique(Landuse13)

#sta_fe<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
#sta_fe
#plot(sta_fe)

sta_fe_P<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/SantaFe_plano", "Sta_fe_plano")
sta_fe_P
plot(sta_fe_P)

proj4string(sta_fe_P)
proj4string(Landuse13)

#projection <- CRS("+proj=utm +zone=21 +south +datum=WGS84 +units=m +no_defs")
#sta_fe_sptr<- spTransform(sta_fe, projection)
#proj4string(sta_fe_sptr)
#extent(sta_fe_sptr)

extent(sta_fe_P)
extent(Landuse13)

Landuse13_prj <- projectRaster(Landuse13, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs",method = "ngb") #se le agrega ngb xq al ser variables categoricas no nos sirve la que es por defecto (un promedio de los dos tipos de clases) sino que necesitamos una sola categoria (un nro entero) con este metodo por lo tanto se selecciona una caterogira (la que predomina)
proj4string(Landuse13_prj)
extent(Landuse13_prj)

unique(getValues(Landuse13_prj))

plot(Landuse13_prj)
plot (sta_fe_P, add = TRUE)

Landuse13_prj_crop <- crop(Landuse13_prj, sta_fe_P)
Landuse13_prj_crop_mask <- mask(Landuse13_prj_crop, sta_fe_P)
plot(Landuse13_prj_crop_mask)
getValues(Landuse13_prj_crop_mask)
class(getValues(Landuse13_prj_crop_mask))

vectorLAND <- getValues(Landuse13_prj_crop_mask)
unique(vectorLAND)

Cultivo <- Landuse13_prj_crop_mask
Cultivo [Cultivo < 12] <- NA
Cultivo [Cultivo > 14] <- NA
Cultivo [Cultivo == 13] <- NA

Cultivo [Cultivo == 12] <- 14
plot(Cultivo)

Pastizal <- Landuse13_prj_crop_mask
Pastizal [Pastizal < 10] <- NA
Pastizal [Pastizal > 10] <- NA
plot (Pastizal)

#Bosque <- Landuse13_prj_crop_mask
#Bosque [Bosque > 5] <- NA
#plot(Bosque)

#Arbustos <- Landuse13_prj_crop_mask
#Arbustos [Arbustos < 7] <- NA
#Arbustos [Arbustos > 7] <- NA
#plot (Arbustos)

#Savanas<- Landuse13_prj_crop_mask
#Savanas [Savanas< 8] <- NA
#Savanas [Savanas > 9] <- NA
#plot (Savanas)

BosquesySavanas<- Landuse13_prj_crop_mask
BosquesySavanas [BosquesySavanas > 9] <- NA
plot (BosquesySavanas)

Ciudad<- Landuse13_prj_crop_mask
Ciudad [Ciudad< 13] <- NA
Ciudad [Ciudad > 13] <- NA
plot (Ciudad)


#Proporcion de pastizales 2013----

writeRaster(x= Pastizal, filename= "Pastizal13P", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))


molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Pastizal13<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Pastizal13P.tif")

molde
Pastizal13

molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs")
molde_rtr

extent(molde_rtr)

extent(Pastizal13)

plot(extent(molde_rtr))
plot(extent(Pastizal13), add=TRUE, col="red")

Pastizal13_extend<- extend (Pastizal13, molde_rtr, value=NA)
Pastizal13_extend
plot(extent(Pastizal13_extend), add=TRUE, col="red")
Pastizal13_extend[is.na(Pastizal13_extend[])]<- 0
plot(Pastizal13_extend)
extent(Pastizal13_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

lecos_grid_4km<- sample_lsm(Pastizal13_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

library(tidyverse)
cl_10_pland<- filter(lecos_grid_4km, class == 10, metric== "pland")

rownames(cl_10_pland)

cl_10_pland_df<- as.data.frame(cl_10_pland)

class(cl_10_pland_df)
head(cl_10_pland_df)
rownames(cl_10_pland_df)<- cl_10_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_10<- full_join(df_plot_id,cl_10_pland_df, by = "plot_id")
class_10[is.na(class_10)] <- 0

lecos_grid_4km_cl_10_pland<- spCbind(grid_4km, class_10)
head(lecos_grid_4km_cl_10_pland@data)
tail(lecos_grid_4km_cl_10_pland@data)
class_10_r<- rasterize(lecos_grid_4km_cl_10_pland,molde_rtr,field="value")
plot(class_10_r)
class(class_10_r)

writeRaster(x= class_10_r, filename= "ProporcionPastizal13P", format= "GTiff", bylayer= TRUE, suffix=names(class_10_r))

extent(class_10_r)

#Proporcion de Bosques 2013----
plot(Bosque)
plot(BosquesySavanas)
writeRaster(x= BosquesySavanas, filename= "BosqueS13P", format= "GTiff", bylayer= TRUE, suffix=names(BosquesySavanas))

molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Bosque13<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/BosqueS13P.tif")
plot(Bosque13)

molde
Bosque13

molde_rtr <- projectRaster(molde, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
molde_rtr

extent(molde_rtr)
extent(Bosque13)

plot(extent(molde_rtr))
plot(extent(Bosque13), add=TRUE, col="red")

Bosque_extend<- extend (Bosque13, molde_rtr, value=NA)
Bosque_extend
plot(extent(Bosque_extend), add=TRUE, col="red")
Bosque_extend[is.na(Bosque_extend[])]<- 0
plot(Bosque_extend)
extent(Bosque_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Bosque_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

library(tidyverse)
cl_9_pland<- filter(lecos_grid_4km, class == 9, metric== "pland")

rownames(cl_9_pland)

cl_9_pland_df<- as.data.frame(cl_9_pland)

class(cl_9_pland_df)
head(cl_9_pland_df)
rownames(cl_9_pland_df)<- cl_9_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

library(dplyr)
class(df_plot_id$plot_id)

class_9<- full_join(df_plot_id,cl_9_pland_df, by = "plot_id")
class_9[is.na(class_9)] <- 0

lecos_grid_4km_cl_9_pland<- spCbind(grid_4km, class_9)
head(lecos_grid_4km_cl_9_pland@data)
tail(lecos_grid_4km_cl_9_pland@data)
class_9_r<- rasterize(lecos_grid_4km_cl_9_pland,molde_rtr,field="value")
plot(class_9_r)
class(class_9_r)

writeRaster(x= class_9_r, filename= "ProporcionBosques13P", format= "GTiff", bylayer= TRUE, suffix=names(class_9_r))

extent(class_9_r)
#Proporcion de Cultivos 2013----
writeRaster(x= Cultivo, filename= "Cultivos13P", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo))


molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
cultivos13<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Cultivos13P.tif")

molde
cultivos13

molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs")
molde_rtr

extent(molde_rtr)
extent(cultivos13)

plot(extent(molde_rtr))
plot(extent(cultivos13), add=TRUE, col="red")

cultivo13_extend<- extend (cultivos13, molde_rtr, value=NA)
cultivo13_extend
plot(extent(cultivo13_extend), add=TRUE, col="red")
cultivo13_extend[is.na(cultivo13_extend[])]<- 0
plot(cultivo13_extend)
extent(cultivo13_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")

lecos_grid_4km<- sample_lsm(cultivo13_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

library(tidyverse)
cl_14_pland<- filter(lecos_grid_4km, class == 14, metric== "pland")

rownames(cl_14_pland)

cl_14_pland_df<- as.data.frame(cl_14_pland)

class(cl_14_pland_df)
head(cl_14_pland_df)
rownames(cl_14_pland_df)<- cl_14_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_14<- full_join(df_plot_id,cl_14_pland_df, by = "plot_id")
class_14[is.na(class_14)] <- 0

lecos_grid_4km_cl_14_pland<- spCbind(grid_4km, class_14)
head(lecos_grid_4km_cl_14_pland@data)
tail(lecos_grid_4km_cl_14_pland@data)
class_14_r<- rasterize(lecos_grid_4km_cl_14_pland,molde_rtr,field="value")
plot(class_14_r)
class(class_14_r)

writeRaster(x= class_14_r, filename= "ProporcionCultivos13P", format= "GTiff", bylayer= TRUE, suffix=names(class_14_r))

extent(class_14_r)

#Proporcion de pastizales 2018----
# Activamos los paquetes necesarios
#x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages(x)
#lapply(x, library, character.only = TRUE)

Landuse18 <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS/LandCover_Type_Yearly_500m_v6/LC1/MCD12Q1_LC1_2018_001.tif")
Landuse18
getValues(Landuse18)
plot(Landuse18)
unique(Landuse18)

sta_fe_P

proj4string(sta_fe_P)
proj4string(Landuse18)

Landuse18_prj <- projectRaster(Landuse18, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs",method = "ngb") 

#sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

proj4string(Landuse18_prj)
proj4string(sta_fe_P)
unique(getValues(Landuse18_prj))
extent(Landuse18_prj)
extent(sta_fe_P)
class(sta_fe_P)

plot(Landuse18_prj)
plot (sta_fe_P, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe_P)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe_P)
plot(Landuse18_prj_crop_mask)
getValues(Landuse18_prj_crop_mask)
class(getValues(Landuse18_prj_crop_mask))

Pastizal <- Landuse18_prj_crop_mask
Pastizal [Pastizal > 10] <- NA
Pastizal [Pastizal < 10] <- NA

plot(Pastizal)
class(Pastizal)


writeRaster(x= Pastizal, filename= "Pastizal18P", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))


molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Pastizal18<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Pastizal18P.tif")

molde
Pastizal18

molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs")
molde_rtr

extent(molde_rtr)
extent(Pastizal18)

plot(extent(molde_rtr))
plot(extent(Pastizal18), add=TRUE, col="red")

Pastizal18_extend<- extend (Pastizal18, molde_rtr, value=NA)
Pastizal18_extend
plot(extent(Pastizal18_extend), add=TRUE, col="red")
Pastizal18_extend[is.na(Pastizal18_extend[])]<- 0
plot(Pastizal18_extend)
extent(Pastizal18_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Pastizal18_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
lecos_grid_4km
tail(lecos_grid_4km)

library(tidyverse)
cl_10_pland<- filter(lecos_grid_4km, class == 10, metric== "pland")

rownames(cl_10_pland)

cl_10_pland_df<- as.data.frame(cl_10_pland)

class(cl_10_pland_df)
head(cl_10_pland_df)
rownames(cl_10_pland_df)<- cl_10_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_10<- full_join(df_plot_id,cl_10_pland_df, by = "plot_id")
class_10[is.na(class_10)] <- 0

lecos_grid_4km_cl_10_pland<- spCbind(grid_4km, class_10)
head(lecos_grid_4km_cl_10_pland@data)
tail(lecos_grid_4km_cl_10_pland@data)
class_10_r<- rasterize(lecos_grid_4km_cl_10_pland,molde_rtr,field="value")
plot(class_10_r)
class(class_10_r)

writeRaster(x= class_10_r, filename= "ProporcionPastizal18P", format= "GTiff", bylayer= TRUE, suffix=names(class_10_r))

extent(class_10_r)


#Para el año 2008----
Landuse8 <- raster("MCD12Q1_LC1_2008_001.tif")
Landuse8
getValues(Landuse8)
plot(Landuse8)
unique(Landuse8)

sta_fe_P

proj4string(sta_fe_P)
proj4string(Landuse8)

Landuse8_prj <- projectRaster(Landuse8, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs",method = "ngb") 
proj4string(Landuse8_prj)
unique(getValues(Landuse8_prj))

plot(Landuse8_prj)
plot (sta_fe_P, add = TRUE)

Landuse8_prj_crop <- crop(Landuse8_prj, sta_fe_P)
Landuse8_prj_crop_mask <- mask(Landuse8_prj_crop, sta_fe_P)
plot(Landuse8_prj_crop_mask)
getValues(Landuse8_prj_crop_mask)
class(getValues(Landuse8_prj_crop_mask))

vectorLAND <- getValues(Landuse8_prj_crop_mask)
unique(vectorLAND)

Cultivo8 <- Landuse8_prj_crop_mask
Cultivo8 [Cultivo8 < 12] <- NA
Cultivo8 [Cultivo8 > 14] <- NA
Cultivo8 [Cultivo8 == 13] <- NA

Cultivo8 [Cultivo8 == 12] <- 14
plot(Cultivo8)

Pastizal8 <- Landuse8_prj_crop_mask
Pastizal8 [Pastizal8 < 10] <- NA
Pastizal8 [Pastizal8 > 10] <- NA
plot (Pastizal8)


Bosques8<- Landuse8_prj_crop_mask
Bosques8 [Bosques8 > 9] <- NA
plot (Bosques8)

Ciudad8<- Landuse8_prj_crop_mask
Ciudad8 [Ciudad8< 13] <- NA
Ciudad8 [Ciudad8 > 13] <- NA
plot (Ciudad8)


#Pastizales 2008----


getwd()

writeRaster(x= Pastizal8, filename= "Pastizal08P", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal8))


#molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Pastizal8<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Pastizal08P.tif")

#molde
Pastizal8

#molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb")
molde_rtr

extent(molde_rtr)
extent(Pastizal8)

plot(extent(molde_rtr))
plot(extent(Pastizal8), add=TRUE, col="red")

Pastizal8_extend<- extend (Pastizal8, molde_rtr, value=NA)
Pastizal8_extend
plot(extent(Pastizal8_extend), add=TRUE, col="red")
Pastizal8_extend[is.na(Pastizal8_extend[])]<- 0
plot(Pastizal8_extend)
extent(Pastizal8_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Pastizal8_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

#library(tidyverse)
cl_10_pland<- filter(lecos_grid_4km, class == 10, metric== "pland")

rownames(cl_10_pland)

cl_10_pland_df<- as.data.frame(cl_10_pland)

class(cl_10_pland_df)
head(cl_10_pland_df)
rownames(cl_10_pland_df)<- cl_10_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

#library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_10<- full_join(df_plot_id,cl_10_pland_df, by = "plot_id")
class_10[is.na(class_10)] <- 0

lecos_grid_4km_cl_10_pland<- spCbind(grid_4km, class_10)
head(lecos_grid_4km_cl_10_pland@data)
tail(lecos_grid_4km_cl_10_pland@data)
class_10_r<- rasterize(lecos_grid_4km_cl_10_pland,molde_rtr,field="value")
plot(class_10_r)
class(class_10_r)

writeRaster(x= class_10_r, filename= "ProporcionPastizal08P", format= "GTiff", bylayer= TRUE, suffix=names(class_10_r))

extent(class_10_r)


#Bosques 2008----
writeRaster(x= Bosques8, filename= "Bosques08P", format= "GTiff", bylayer= TRUE, suffix=names(Bosques8))

Bosque8<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Bosques08P.tif")

Bosque8

molde_rtr

extent(molde_rtr)
extent(Bosque8)

plot(extent(molde_rtr))
plot(extent(Bosque8), add=TRUE, col="red")

Bosque8_extend<- extend (Bosque8, molde_rtr, value=NA)
Bosque8_extend
plot(extent(Bosque8_extend), add=TRUE, col="red")
Bosque8_extend[is.na(Bosque8_extend[])]<- 0
plot(Bosque8_extend)
extent(Bosque8_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Bosque8_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

#library(tidyverse)
cl_10_pland<- filter(lecos_grid_4km, class == 9, metric== "pland")

rownames(cl_10_pland)

cl_10_pland_df<- as.data.frame(cl_10_pland)

class(cl_10_pland_df)
head(cl_10_pland_df)
rownames(cl_10_pland_df)<- cl_10_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

#library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_10<- full_join(df_plot_id,cl_10_pland_df, by = "plot_id")
class_10[is.na(class_10)] <- 0

lecos_grid_4km_cl_10_pland<- spCbind(grid_4km, class_10)
head(lecos_grid_4km_cl_10_pland@data)
tail(lecos_grid_4km_cl_10_pland@data)
class_10_r<- rasterize(lecos_grid_4km_cl_10_pland,molde_rtr,field="value")
plot(class_10_r)
class(class_10_r)

writeRaster(x= class_10_r, filename= "ProporcionBosque08P", format= "GTiff", bylayer= TRUE, suffix=names(class_10_r))

extent(class_10_r)
#Cultivos 2008----
writeRaster(x= Cultivo8, filename= "Cultivos08P", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo8))

Cultivos8<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Cultivos08P.tif")

Cultivos8

molde_rtr

extent(molde_rtr)
extent(Cultivos8)

plot(extent(molde_rtr))
plot(extent(Cultivos8), add=TRUE, col="red")

Cultivos8_extend<- extend (Cultivos8, molde_rtr, value=NA)
Cultivos8_extend
plot(extent(Cultivos8_extend), add=TRUE, col="red")
Cultivos8_extend[is.na(Cultivos8_extend[])]<- 0
plot(Cultivos8_extend)
extent(Cultivos8_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Cultivos8_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

#library(tidyverse)
cl_10_pland<- filter(lecos_grid_4km, class == 14, metric== "pland")

rownames(cl_10_pland)

cl_10_pland_df<- as.data.frame(cl_10_pland)

class(cl_10_pland_df)
head(cl_10_pland_df)
rownames(cl_10_pland_df)<- cl_10_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

#library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_10<- full_join(df_plot_id,cl_10_pland_df, by = "plot_id")
class_10[is.na(class_10)] <- 0

lecos_grid_4km_cl_10_pland<- spCbind(grid_4km, class_10)
head(lecos_grid_4km_cl_10_pland@data)
tail(lecos_grid_4km_cl_10_pland@data)
class_10_r<- rasterize(lecos_grid_4km_cl_10_pland,molde_rtr,field="value")
plot(class_10_r)
class(class_10_r)

writeRaster(x= class_10_r, filename= "ProporcionCultivos08P", format= "GTiff", bylayer= TRUE, suffix=names(class_10_r))

extent(class_10_r)

#para el año 2003----
Landuse3 <- raster("MCD12Q1_LC1_2003_001.tif")
Landuse3
plot(Landuse3)
unique(Landuse3)

proj4string(sta_fe_P)
proj4string(Landuse3)

Landuse3_prj <- projectRaster(Landuse3, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs",method = "ngb")

proj4string(Landuse3_prj)

unique(getValues(Landuse3_prj))

plot(Landuse3_prj)
plot (sta_fe_P, add = TRUE)

Landuse3_prj_crop <- crop(Landuse3_prj, sta_fe_P)
Landuse3_prj_crop_mask <- mask(Landuse3_prj_crop, sta_fe_P)
plot(Landuse3_prj_crop_mask)
getValues(Landuse3_prj_crop_mask)
class(getValues(Landuse3_prj_crop_mask))

vectorLAND <- getValues(Landuse3_prj_crop_mask)
unique(vectorLAND)

Cultivo3 <- Landuse3_prj_crop_mask
Cultivo3 [Cultivo3 < 12] <- NA
Cultivo3 [Cultivo3 > 14] <- NA
Cultivo3 [Cultivo3 == 13] <- NA

Cultivo3 [Cultivo3 == 12] <- 14
plot(Cultivo3)

Pastizal3 <- Landuse3_prj_crop_mask
Pastizal3 [Pastizal3 < 10] <- NA
Pastizal3 [Pastizal3 > 10] <- NA
plot (Pastizal3)

Bosques3<- Landuse3_prj_crop_mask
Bosques3 [Bosques3 > 9] <- NA
plot (Bosques3)

Ciudad3<- Landuse3_prj_crop_mask
Ciudad3 [Ciudad3< 13] <- NA
Ciudad3 [Ciudad3 > 13] <- NA
plot (Ciudad3)


#Pastizales 2003----

getwd()


writeRaster(x= Pastizal3, filename= "Pastizal03P", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal3))


#molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Pastizal3<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Pastizal03P.tif")

#molde
Pastizal3

extent(molde_rtr)
extent(Pastizal3)

plot(extent(molde_rtr))
plot(extent(Pastizal3), add=TRUE, col="red")

Pastizal3_extend<- extend (Pastizal3, molde_rtr, value=NA)
Pastizal3_extend
plot(extent(Pastizal3_extend), add=TRUE, col="red")
Pastizal3_extend[is.na(Pastizal3_extend[])]<- 0
plot(Pastizal3_extend)
extent(Pastizal3_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Pastizal3_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

#library(tidyverse)
cl_10_pland<- filter(lecos_grid_4km, class == 10, metric== "pland")

rownames(cl_10_pland)

cl_10_pland_df<- as.data.frame(cl_10_pland)

class(cl_10_pland_df)
head(cl_10_pland_df)
rownames(cl_10_pland_df)<- cl_10_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

#library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_10<- full_join(df_plot_id,cl_10_pland_df, by = "plot_id")
class_10[is.na(class_10)] <- 0

lecos_grid_4km_cl_10_pland<- spCbind(grid_4km, class_10)
head(lecos_grid_4km_cl_10_pland@data)
tail(lecos_grid_4km_cl_10_pland@data)
class_10_r<- rasterize(lecos_grid_4km_cl_10_pland,molde_rtr,field="value")
plot(class_10_r)
class(class_10_r)

writeRaster(x= class_10_r, filename= "ProporcionPastizal03P", format= "GTiff", bylayer= TRUE, suffix=names(class_10_r))

extent(class_10_r)

#Bosques 2003----
plot(Bosques3)
writeRaster(x= Bosques3, filename= "Bosques03P", format= "GTiff", bylayer= TRUE, suffix=names(Bosques3))

#molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Bosque<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Bosques03P.tif")
#molde_rtr <- projectRaster(molde, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
molde_rtr

extent(molde_rtr)
extent(Bosque)

plot(extent(molde_rtr))
plot(extent(Bosque), add=TRUE, col="red")

Bosque_extend<- extend (Bosque, molde_rtr, value=NA)
Bosque_extend
plot(extent(Bosque_extend), add=TRUE, col="red")
Bosque_extend[is.na(Bosque_extend[])]<- 0
plot(Bosque_extend)
extent(Bosque_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Bosque_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

library(tidyverse)
cl_9_pland<- filter(lecos_grid_4km, class == 9, metric== "pland")

rownames(cl_9_pland)

cl_9_pland_df<- as.data.frame(cl_9_pland)

class(cl_9_pland_df)
head(cl_9_pland_df)
rownames(cl_9_pland_df)<- cl_9_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_9<- full_join(df_plot_id,cl_9_pland_df, by = "plot_id")
class_9[is.na(class_9)] <- 0

lecos_grid_4km_cl_9_pland<- spCbind(grid_4km, class_9)
head(lecos_grid_4km_cl_9_pland@data)
tail(lecos_grid_4km_cl_9_pland@data)
class_9_r<- rasterize(lecos_grid_4km_cl_9_pland,molde_rtr,field="value")
plot(class_9_r)
class(class_9_r)

writeRaster(x= class_9_r, filename= "ProporcionBosques03P", format= "GTiff", bylayer= TRUE, suffix=names(class_9_r))

extent(class_9_r)

#Cultivos 2003----
writeRaster(x= Cultivo3, filename= "Cultivos03P", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo3))


#molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
cultivos<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Cultivos03P.tif")

#molde
cultivos

#molde_rtr <- projectRaster(molde, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
molde_rtr

extent(molde_rtr)
extent(cultivos)

plot(extent(molde_rtr))
plot(extent(cultivos), add=TRUE, col="red")

cultivo_extend<- extend (cultivos, molde_rtr, value=NA)
cultivo_extend
plot(extent(cultivo_extend), add=TRUE, col="red")
cultivo_extend[is.na(cultivo_extend[])]<- 0
plot(cultivo_extend)
extent(cultivo_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(cultivo_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

#library(tidyverse)
cl_14_pland<- filter(lecos_grid_4km, class == 14, metric== "pland")

rownames(cl_14_pland)

cl_14_pland_df<- as.data.frame(cl_14_pland)

class(cl_14_pland_df)
head(cl_14_pland_df)
rownames(cl_14_pland_df)<- cl_14_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

#library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_14<- full_join(df_plot_id,cl_14_pland_df, by = "plot_id")
class_14[is.na(class_14)] <- 0

lecos_grid_4km_cl_14_pland<- spCbind(grid_4km, class_14)
head(lecos_grid_4km_cl_14_pland@data)
tail(lecos_grid_4km_cl_14_pland@data)
class_14_r<- rasterize(lecos_grid_4km_cl_14_pland,molde_rtr,field="value")
plot(class_14_r)
class(class_14_r)

writeRaster(x= class_14_r, filename= "ProporcionCultivos03P", format= "GTiff", bylayer= TRUE, suffix=names(class_14_r))

extent(class_14_r)

#Bosques para el año 2018----
Landuse18 <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS/LandCover_Type_Yearly_500m_v6/LC1/MCD12Q1_LC1_2018_001.tif")
Landuse18
plot(Landuse18)
unique(Landuse18)

sta_fe_P

proj4string(sta_fe_P)
proj4string(Landuse18_prj)

unique(getValues(Landuse18_prj))

plot(Landuse18_prj)
plot (sta_fe_P, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe_P)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe_P)
plot(Landuse18_prj_crop_mask)

Bosque <- Landuse18_prj_crop_mask
Bosque [Bosque > 9] <- NA
Bosque [Bosque < 9] <- 9
extent(Bosque)
plot(Bosque)

writeRaster(x= Bosque, filename= "Bosque18P", format= "GTiff", bylayer= TRUE, suffix=names(Bosque))


molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Bosque<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Bosque18P.tif")

molde
Bosque

molde_rtr <- projectRaster(molde, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
molde_rtr

extent(molde_rtr)
extent(Bosque)

plot(extent(molde_rtr))
plot(extent(Bosque), add=TRUE, col="red")

Bosque_extend<- extend (Bosque, molde_rtr, value=NA)
Bosque_extend
plot(extent(Bosque_extend), add=TRUE, col="red")
Bosque_extend[is.na(Bosque_extend[])]<- 0
plot(Bosque_extend)
extent(Bosque_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Bosque_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

library(tidyverse)
cl_9_pland<- filter(lecos_grid_4km, class == 9, metric== "pland")

rownames(cl_9_pland)

cl_9_pland_df<- as.data.frame(cl_9_pland)

class(cl_9_pland_df)
head(cl_9_pland_df)
rownames(cl_9_pland_df)<- cl_9_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_9<- full_join(df_plot_id,cl_9_pland_df, by = "plot_id")
class_9[is.na(class_9)] <- 0

lecos_grid_4km_cl_9_pland<- spCbind(grid_4km, class_9)
head(lecos_grid_4km_cl_9_pland@data)
tail(lecos_grid_4km_cl_9_pland@data)
class_9_r<- rasterize(lecos_grid_4km_cl_9_pland,molde_rtr,field="value")
plot(class_9_r)
class(class_9_r)

writeRaster(x= class_9_r, filename= "ProporcionBosques18P", format= "GTiff", bylayer= TRUE, suffix=names(class_9_r))

extent(class_9_r)



#Para cultivos----

# Activamos los paquetes necesarios
x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages(x) # warning: uncommenting this may take a number of minutes
lapply(x, library, character.only = TRUE)

Landuse18 <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS/LandCover_Type_Yearly_500m_v6/LC1/MCD12Q1_LC1_2018_001.tif")
Landuse18
plot(Landuse18)
unique(Landuse18)

sta_fe<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
plot(sta_fe)

proj4string(sta_fe)
proj4string(Landuse18)

Landuse18_prj <- projectRaster(Landuse18, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")

proj4string(Landuse18_prj)
unique(getValues(Landuse18_prj))

plot(Landuse18_prj)
plot (sta_fe_P, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe)
plot(Landuse18_prj_crop_mask)

Cultivo <- Landuse18_prj_crop_mask
Cultivo [Cultivo < 12] <- NA
Cultivo [Cultivo > 14] <- NA
Cultivo [Cultivo == 13] <- NA

Cultivo [Cultivo == 12] <- 14
plot(Cultivo)

getwd()

writeRaster(x= Cultivo, filename= "Cultivos18P", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo))


molde<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
cultivos<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Cultivos18P.tif")

molde
cultivos

molde_rtr <- projectRaster(molde, crs="+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")
molde_rtr

extent(molde_rtr)
extent(cultivos)

plot(extent(molde_rtr))
plot(extent(cultivos), add=TRUE, col="red")

cultivo_extend<- extend (cultivos, molde_rtr, value=NA)
cultivo_extend
plot(extent(cultivo_extend), add=TRUE, col="red")
cultivo_extend[is.na(cultivo_extend[])]<- 0
plot(cultivo_extend)
extent(cultivo_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")

#library(landscapemetrics)
lecos_grid_4km<- sample_lsm(cultivo_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)

#library(tidyverse)
cl_14_pland<- filter(lecos_grid_4km, class == 14, metric== "pland")

rownames(cl_14_pland)

cl_14_pland_df<- as.data.frame(cl_14_pland)

class(cl_14_pland_df)
head(cl_14_pland_df)
rownames(cl_14_pland_df)<- cl_14_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

#library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_14<- full_join(df_plot_id,cl_14_pland_df, by = "plot_id")
class_14[is.na(class_14)] <- 0

lecos_grid_4km_cl_14_pland<- spCbind(grid_4km, class_14)
head(lecos_grid_4km_cl_14_pland@data)
tail(lecos_grid_4km_cl_14_pland@data)
class_14_r<- rasterize(lecos_grid_4km_cl_14_pland,molde_rtr,field="value")
plot(class_14_r)
class(class_14_r)

writeRaster(x= class_14_r, filename= "ProporcionCultivos18P", format= "GTiff", bylayer= TRUE, suffix=names(class_14_r))

extent(class_14_r)

#Para ciudades----
x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
lapply(x, library, character.only = TRUE)

Landuse18 <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS/LandCover_Type_Yearly_500m_v6/LC1/MCD12Q1_LC1_2018_001.tif")
getValues(Landuse18)
plot(Landuse18)
unique(Landuse18)

sta_fe<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
plot(sta_fe)

proj4string(sta_fe)
proj4string(Landuse18)

Landuse18_prj <- projectRaster(Landuse18, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")

sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(sta_fe_sptr)
proj4string(Landuse18_prj)
extent(sta_fe_sptr)
extent(Landuse18_prj)

unique(getValues(Landuse18_prj))
class(sta_fe_sptr)

plot(Landuse18_prj)
plot (sta_fe, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe)
plot(Landuse18_prj_crop_mask)
getValues(Landuse18_prj_crop_mask)
class(getValues(Landuse18_prj_crop_mask))

Ciudad<- Landuse18_prj_crop_mask
Ciudad [Ciudad< 13] <- NA
Ciudad [Ciudad > 13] <- NA
plot (Ciudad)

writeRaster(x= Ciudad, filename= "Ciudad18P", format= "GTiff", bylayer= TRUE, suffix=names(Ciudad))

distCd <- distance(Ciudad)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_sptr)
distCd_crop_mask <- mask(distCd_crop, sta_fe_sptr)
plot(distCd_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades18P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))

#Ciudades 2013

Ciudad<- Landuse13_prj_crop_mask
Ciudad [Ciudad< 13] <- NA
Ciudad [Ciudad > 13] <- NA
plot (Ciudad)

writeRaster(x= Ciudad, filename= "Ciudad13P", format= "GTiff", bylayer= TRUE, suffix=names(Ciudad))

distCd <- distance(Ciudad)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_sptr)
distCd_crop_mask <- mask(distCd_crop, sta_fe_sptr)
plot(distCd_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades13P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))

#Ciudades 2008
Ciudad<- Landuse8_prj_crop_mask
Ciudad [Ciudad< 13] <- NA
Ciudad [Ciudad > 13] <- NA
plot (Ciudad)

writeRaster(x= Ciudad, filename= "Ciudad08P", format= "GTiff", bylayer= TRUE, suffix=names(Ciudad))

distCd <- distance(Ciudad)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_sptr)
distCd_crop_mask <- mask(distCd_crop, sta_fe_sptr)
plot(distCd_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades08P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))

#Ciudades 2003
Ciudad<- Landuse3_prj_crop_mask
Ciudad [Ciudad< 13] <- NA
Ciudad [Ciudad > 13] <- NA
plot (Ciudad)

writeRaster(x= Ciudad, filename= "Ciudad03P", format= "GTiff", bylayer= TRUE, suffix=names(Ciudad))

distCd <- distance(Ciudad)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_sptr)
distCd_crop_mask <- mask(distCd_crop, sta_fe_sptr)
plot(distCd_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCiudades03P", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))


#Promedio capas MODIS----
x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages('raster')

lapply(x, library, character.only = TRUE)

path<- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Bosques"
setwd(path)
getwd()

#Para Bosques PROM----
files = list.files(pattern = '*.tif', full.names = TRUE)
class(files)
Bosques_stack <- stack(files)
class(Bosques_stack)

Bosques_stack_prom <- calc(Bosques_stack,mean)
Bosques_stack_prom
plot(Bosques_stack_prom)
writeRaster(x= Bosques_stack_prom, filename= "Bosques_Prom", format= "GTiff")

#Para Pastizales PROM----
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

#Para Cultivos PROM----
path<- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Cultivos"
setwd(path)

files = list.files(path,pattern = '*.tif', full.names = TRUE)
class(files)
Cultivos_stack <- stack(files)
class(Cultivos_stack)

Cultivos_stack_prom <- calc(Cultivos_stack,mean)
Cultivos_stack_prom
plot(Cultivos_stack_prom)
writeRaster(x= Cultivos_stack_prom, filename= "Cultivos_Prom", format= "GTiff")

#Para ciudades PROM----
path<- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Ciudades"
setwd(path)
getwd()
files = list.files(path,pattern = '*.tif', full.names = TRUE)
class(files)
Ciudades_stack <- stack(files)
class(Ciudades_stack)

Ciudades_stack_prom <- calc(Ciudades_stack,mean)
Ciudades_stack_prom
plot(Ciudades_stack_prom)
writeRaster(x= Ciudades_stack_prom, filename= "Ciudades_Prom", format= "GTiff")


#Probando reproyectar a plano----
ciudad_PRom <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Ciudades/Ciudades_Prom.tif")
extent(ciudad_PRom)
proj4string(ciudad_PRom)
CiudadProm_prj <- projectRaster(ciudad_PRom, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs",method = "ngb") 
proj4string(CiudadProm_prj)
extent(CiudadProm_prj)

writeRaster(x= CiudadProm_prj, filename= "Ciudades_Prom_prj", format= "GTiff")
plot(CiudadProm_prj)

bosque_prom <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Bosques/Bosques_Prom.tif")
pastizal_prom <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Pastizales/Pastizales_Prom.tif")
cultivo_prom <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/Cultivos/Cultivos_Prom.tif")

proj4string(pastizal_prom)
extent(cultivo_prom)



rutas <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Maxent 2023/rutas.tif")
aguastemp <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Maxent 2023/ProporcionAguasTempSF.tif")
aguasperm <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Maxent 2023/lagperm_sync.tif")
ciudadviejo <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Variables/ciudad_sync.tif")

proj4string(rutas)
extent(rutas)
extent(aguastemp)
extent(aguasperm)

plot(extent(rutas))
plot(extent(distCd_crop_mask), add=TRUE, col="red")

ciudad_extend<- extend (distCd_crop_mask, rutas, value=NA)
ciudad_extend
plot(extent(ciudad_extend), add=TRUE, col="red")
ciudad_extend[is.na(ciudad_extend[])]<- 0
plot(ciudad_extend)
extent(ciudad_extend)


current_extent <- extent(ciudad_extend)

# Modify the xmin and xmax values
new_xmin <- 5193323
new_xmax <- 5633993
current_extent@xmin <- new_xmin
current_extent@xmax <- new_xmax

# Update the extent of the raster layer
extent(ciudad_extend) <- current_extent

# Print the modified extent
print(extent(ciudad_extend))

writeRaster(x= ciudad_extend, filename= "Ciudades_corregido", format= "GTiff")

#probar hacer el stack files----
filesM = list.files(pattern = '*.tif', full.names = TRUE)
class(filesM)
Max_stack <- stack(filesM)

Bio1 <- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Maxent 2023/C_pl_Bio1.tif")
extent(Bio1)
extent(distCd_crop_mask)
