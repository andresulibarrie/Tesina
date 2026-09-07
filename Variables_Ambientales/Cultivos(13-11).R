# Activamos los paquetes necesarios
x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages(x) # warning: uncommenting this may take a number of minutes
lapply(x, library, character.only = TRUE)

Landuse18 <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS/LandCover_Type_Yearly_500m_v6/LC1/MCD12Q1_LC1_2018_001.tif")
Landuse18
getValues(Landuse18)
plot(Landuse18)
unique(Landuse18)

sta_fe<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
sta_fe
plot(sta_fe)
# Tabla de atributos
head(sta_fe@data)

sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

proj4string(sta_fe)
proj4string(sta_fe_sptr)
proj4string(Landuse18)

extent(sta_fe_sptr)

Landuse18_prj <- projectRaster(Landuse18, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb")

proj4string(Landuse18_prj)
extent(Landuse18_prj)
unique(getValues(Landuse18_prj))
class(sta_fe_sptr)

plot(Landuse18_prj)
plot (sta_fe_sptr, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe_sptr)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe_sptr)
plot(Landuse18_prj_crop_mask)
getValues(Landuse18_prj_crop_mask)
class(getValues(Landuse18_prj_crop_mask))

Cultivo <- Landuse18_prj_crop_mask
Cultivo [Cultivo < 12] <- NA
Cultivo [Cultivo > 14] <- NA
Cultivo [Cultivo == 13] <- NA

Cultivo [Cultivo == 12] <- 14
plot(Cultivo)
class(Cultivo)

getwd()
save.image("Cultivo(13-11).RData")
load("C:/Users/Usuario/Downloads/1AGUARATESINA/9 R stuff/ArchivosR/Cultivo(13-11).RData")

writeRaster(x= Cultivo, filename= "Cultivos_13-11", format= "GTiff", bylayer= TRUE, suffix=names(Cultivo))


molde<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
cultivos<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/Cultivos_13-11.tif")

molde
cultivos

molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb")
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
class(sample_plots)
str(sample_plots)
#plot(sample_plots)

library(landscapemetrics)
lecos_grid_4km<- sample_lsm(cultivo_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)
#class 0= no cultivo, class 14 = cultivo
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

writeRaster(x= class_14_r, filename= "ProporcionCultivos13-11SF", format= "GTiff", bylayer= TRUE, suffix=names(class_14_r))

extent(class_14_r)

#segunda parte
#comparar con datos de presencia y con la muestra representativa

ProCul_tif <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/ProporcionCultivos13-11SF.tif")
plot(ProCul_tif)

library(dismo)
bgCul <- randomPoints(ProCul_tif, n=1000) 
plot(bgCul)
proj4string(ProCul_tif)
points(bgCul)
bgCul
dim(bgCul)
class(bgCul)

bgCul_df <- as.data.frame(bgCul)
plot(bgCul_df)
class(bgCul_df) 

head(bgCul_df)
Usosdesuelo<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/randompoints.csv"
write.table(x = bgCul_df, file= Usosdesuelo, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

.rs.unloadPackage("tidyr")

bgCul_df_extrac<- extract(ProCul_tif,bgCul_df) #aca da error si no desactivo el paquete tidyr

class(bgCul_df_extrac)
head(bgCul_df_extrac)
varCul_df <- as.data.frame(bgCul_df_extrac)
head(varCul_df)

dataCul_df<- cbind(bgCul_df,varCul_df)
head(dataCul_df)
boxplot(dataCul_df)

group<- rep("bgr",1000)
head(group) 

data_bggruop<- cbind(dataCul_df,group) #cbind une por columnas
head(data_bggruop)
names(data_bggruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropCultivos","group")


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/0 basesdedatos/BASE DE DATOS Chrysocyon Santa Fe - completada.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)

AG<- data_aguara[,c("Lat_DecimNeg","Long_DecimNeg")] #colnames comando para cambiar los nombres de las columnas
AG_data<- AG[complete.cases(AG),]
AG_data2 <- AG_data [,c("Long_DecimNeg","Lat_DecimNeg")]
head(AG_data2)
tail(AG_data2)

#coords planas("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs")

plot(ProCul_tif) 
points(AG_data2)

AG_data2_spdf <- cbind(AG_data2,id= 1:length(AG_data2[,1])) 
head(AG_data2_spdf)
coordinates(AG_data2_spdf) <- c("Long_DecimNeg", "Lat_DecimNeg")  # set spatial coordinates
class(AG_data2_spdf)
AG_data2_spdf@data
AG_data2_spdf@coords

sta_fe_sptr
plot(sta_fe_sptr)
head(sta_fe_sptr@data)

proj4string(sta_fe_sptr)
proj4string(AG_data2_spdf)

extent(sta_fe_sptr)
extent(AG_data2_spdf)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") 
projection(AG_data2_spdf) <- crs.geo

AG_data2_spdf <- spTransform(AG_data2_spdf, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

AG_data2_stafe <-AG_data2_spdf[!is.na(over(AG_data2_spdf,as(sta_fe_sptr, "SpatialPolygons"))),]
plot(AG_data2_stafe,add=TRUE) #ploteamos el spatial poligons y le adicionamos el spatial points

#tablaqgis<- "C:/Users/Usuario/Downloads/1AGUARATESINA/0 basesdedatos/AG_data2_stafe.csv"
#write.table(x = AG_data2_stafe, file= tablaqgis, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)



AG_data2_stafe_extrac<- extract(ProCul_tif,AG_data2_stafe)
head(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac)
AG_data2_stafe_extrac_df <- as.data.frame(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac_df)
class(AG_data2_stafe)
class(AG_data2_stafe@coords) #dentro de un spatial points data frame puedo observar la tabla de atributos con @data o las coordenadas con @coords
coord_df_AG_Cul <- as.data.frame(AG_data2_stafe@coords) #con este paso transformamos la matriz de corrdenadas en un data frame
head(coord_df_AG_Cul)

data_AG_Cul <- cbind(coord_df_AG_Cul, AG_data2_stafe_extrac_df) # para unir los data frame de las coordenadas y el de la info de la proporcion de cultivos

#la condicion para unir 2 columnas mediante sus filas es necesario que sus nombres sean exactamente iguales, por eso en el proximo paso cambio el nombre de las dos primeras columnas de uno de los objetos
head(data_AG_Cul)
tail(data_AG_Cul)
head(dataCul_df)

names(dataCul_df)
names(data_AG_Cul)

names(dataCul_df)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropCultivos") 
names(data_AG_Cul)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropCultivos")


dim(data_AG_Cul)
groupP<- rep("pres",504)
head(groupP)
data_AGgruop<- cbind(data_AG_Cul,groupP)
names(data_AGgruop)
names(data_AGgruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropCultivos","group")

data_total_Cul <- rbind(data_AGgruop, data_bggruop)
tail(data_total_Cul)
dim(data_total_Cul)

boxplot(PropCultivos~group,data=data_total_Cul)

#hist() como era la funcion histograma

load("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/.RData")
save.image("Cultivos_13-11.RData")

propcult<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/propcultivos13-11.csv"
write.table(x = data_total_Cul, file= propcult, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)
