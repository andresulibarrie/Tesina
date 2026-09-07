# Activamos los paquetes necesarios
x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages(x)
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

proj4string(sta_fe)
proj4string(Landuse18)

Landuse18_prj <- projectRaster(Landuse18, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb")

sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

proj4string(sta_fe_sptr)
proj4string(Landuse18_prj)
unique(getValues(Landuse18_prj))
class(sta_fe_sptr)

plot(Landuse18_prj)
plot (sta_fe_sptr, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe_sptr)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe_sptr)
plot(Landuse18_prj_crop_mask)
getValues(Landuse18_prj_crop_mask)
class(getValues(Landuse18_prj_crop_mask))

Bosque <- Landuse18_prj_crop_mask
Bosque [Bosque > 9] <- NA
Bosque [Bosque < 9] <- 9

plot(Bosque)
class(Bosque)

getwd()
save.image("Bosque.RData")
load("C:/Users/Usuario/Downloads/1AGUARATESINA/9 R stuff/ArchivosR/Bosque.RData")

writeRaster(x= Bosque, filename= "Bosque", format= "GTiff", bylayer= TRUE, suffix=names(Bosque))


molde<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Bosque<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/Bosque.tif")

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

library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Bosque_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
lecos_grid_4km
tail(lecos_grid_4km)
#class 0= no Bosque, class 9 = Bosque
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

writeRaster(x= class_9_r, filename= "ProporcionBosquesSF", format= "GTiff", bylayer= TRUE, suffix=names(class_9_r))

extent(class_9_r)

#segunda parte
#comparar con datos de presencia y con la muestra representativa

ProBosq_tif <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/ProporcionBosquesSF.tif")
plot(ProBosq_tif)

library(dismo)
#cargar los bg de cultivos
bgBosq_df<- read.table (file="C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/randompoints.csv",                        
                        header = TRUE, sep = ";", 
                        dec = ".", row.names = NULL,
                        as.is = TRUE)

plot(bgBosq_df)
class(bgBosq_df) 

head(bgBosq_df)

.rs.unloadPackage("tidyr")

bgBosq_df_extrac<- extract(ProBosq_tif,bgBosq_df) #aca da error si no desactivo el paquete tidyr

class(bgBosq_df_extrac)
head(bgBosq_df_extrac)
varBosq_df <- as.data.frame(bgBosq_df_extrac)
head(varBosq_df)

dataBosq_df<- cbind(bgBosq_df,varBosq_df)
head(dataBosq_df)
boxplot(dataBosq_df)

group<- rep("bgr",1000)
head(group) 

data_bggruop<- cbind(dataBosq_df,group) #cbind une por columnas
head(data_bggruop)
names(data_bggruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropBosques","group")


data_aguara<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/0 basesdedatos/BASE DE DATOS Chrysocyon Santa Fe - completada.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)

AG<- data_aguara[,c("Lat_DecimNeg","Long_DecimNeg")] #colnames comando para cambiar los nombres de las columnas
AG_data<- AG[complete.cases(AG),]
AG_data2 <- AG_data [,c("Long_DecimNeg","Lat_DecimNeg")]
head(AG_data2)
tail(AG_data2)

plot(ProBosq_tif) 
points(AG_data2)

AG_data2_spdf <- cbind(AG_data2,id= 1:length(AG_data2[,1])) 
head(AG_data2_spdf)
coordinates(AG_data2_spdf) <- c("Long_DecimNeg", "Lat_DecimNeg")  # set spatial coordinates
class(AG_data2_spdf)
AG_data2_spdf@data

plot(sta_fe_sptr)
head(sta_fe_sptr@data)

proj4string(sta_fe_sptr)
proj4string(AG_data2_spdf)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") 
projection(AG_data2_spdf) <- crs.geo

AG_data2_spdf <- spTransform(AG_data2_spdf, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

AG_data2_stafe <-AG_data2_spdf[!is.na(over(AG_data2_spdf,as(sta_fe_sptr, "SpatialPolygons"))),]
plot(AG_data2_stafe,add=TRUE) #ploteamos el spatial poligons y le adicionamos el spatial points

AG_data2_stafe_extrac<- extract(ProBosq_tif,AG_data2_stafe)
head(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac)
AG_data2_stafe_extrac_df <- as.data.frame(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac_df)
class(AG_data2_stafe)
class(AG_data2_stafe@coords) #dentro de un spatial points data frame puedo observar la tabla de atributos con @data o las coordenadas con @coords
coord_df_AG_Bosq <- as.data.frame(AG_data2_stafe@coords) #con este paso transformamos la matriz de corrdenadas en un data frame
head(coord_df_AG_Bosq)

data_AG_Bosq <- cbind(coord_df_AG_Bosq, AG_data2_stafe_extrac_df) # para unir los data frame de las coordenadas y el de la info de la proporcion de Bosques

head(data_AG_Bosq)
head(dataBosq_df)

names(dataBosq_df)
names(data_AG_Bosq)

names(dataBosq_df)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropBosques") 
names(data_AG_Bosq)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropBosques")


dim(data_AG_Bosq)
groupP<- rep("pres",504)
head(groupP)
data_AGgruop<- cbind(data_AG_Bosq,groupP)
names(data_AGgruop)
names(data_AGgruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropBosques","group")

data_total_Bosq <- rbind(data_AGgruop, data_bggruop)
head(data_total_Bosq)
dim(data_total_Bosq)

boxplot(PropBosques~group,data=data_total_Bosq)

save.image("Bosques.RData")
load("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/Bosques.RData")

propbosques<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/propbosques.csv"
write.table(x = data_total_Bosq, file= propbosques, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)
