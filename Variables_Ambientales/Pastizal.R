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

Landuse18_prj <- projectRaster(Landuse18, crs= "+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb")

sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

proj4string(Landuse18_prj)
proj4string(sta_fe_sptr)
unique(getValues(Landuse18_prj))
extent(Landuse18_prj)
extent(sta_fe_sptr)
class(sta_fe_sptr)

plot(Landuse18_prj)
plot (sta_fe_sptr, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe_sptr)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe_sptr)
plot(Landuse18_prj_crop_mask)
getValues(Landuse18_prj_crop_mask)
class(getValues(Landuse18_prj_crop_mask))

Pastizal <- Landuse18_prj_crop_mask
Pastizal [Pastizal > 10] <- NA
Pastizal [Pastizal < 10] <- NA

plot(Pastizal)
class(Pastizal)

getwd()
save.image("Pastizal.RData")
load("C:/Users/Usuario/Downloads/1AGUARATESINA/9 R stuff/ArchivosR/Pastizal.RData")

writeRaster(x= Pastizal, filename= "Pastizal", format= "GTiff", bylayer= TRUE, suffix=names(Pastizal))


molde<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
Pastizal<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/Pastizal.tif")

molde
Pastizal

molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb")
molde_rtr

extent(molde_rtr)
extent(Pastizal)

plot(extent(molde_rtr))
plot(extent(Pastizal), add=TRUE, col="red")

Pastizal_extend<- extend (Pastizal, molde_rtr, value=NA)
Pastizal_extend
plot(extent(Pastizal_extend), add=TRUE, col="red")
Pastizal_extend[is.na(Pastizal_extend[])]<- 0
plot(Pastizal_extend)
extent(Pastizal_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)

library(landscapemetrics)
lecos_grid_4km<- sample_lsm(Pastizal_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
lecos_grid_4km
tail(lecos_grid_4km)
#class 0= no Pastizal, class 10 = Pastizal
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

writeRaster(x= class_10_r, filename= "ProporcionPastizalF", format= "GTiff", bylayer= TRUE, suffix=names(class_10_r))

extent(class_10_r)

#segunda parte
#comparar con datos de presencia y con la muestra representativa

ProPast_tif <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/ProporcionPastizalF.tif")
plot(ProPast_tif)

library(dismo)
#cargar los bg de cultivos
bgPast_df<- read.table (file="C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/randompoints.csv",                        
                        header = TRUE, sep = ";", 
                        dec = ".", row.names = NULL,
                        as.is = TRUE)

plot(bgPast_df)
class(bgPast_df) 

head(bgPast_df)

.rs.unloadPackage("tidyr")

bgPast_df_extrac<- extract(ProPast_tif,bgPast_df) #aca da error si no desactivo el paquete tidyr

class(bgPast_df_extrac)
head(bgPast_df_extrac)
varPast_df <- as.data.frame(bgPast_df_extrac)
head(varPast_df)

dataPast_df<- cbind(bgPast_df,varPast_df)
head(dataPast_df)
boxplot(dataPast_df)

group<- rep("bgr",1000)
head(group) 

data_bggruop<- cbind(dataPast_df,group) #cbind une por columnas
head(data_bggruop)
names(data_bggruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropPastizal","group")


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/0 basesdedatos/BASE DE DATOS Chrysocyon Santa Fe - completada.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)

AG<- data_aguara[,c("Lat_DecimNeg","Long_DecimNeg")] #colnames comando para cambiar los nombres de las columnas
AG_data<- AG[complete.cases(AG),]
AG_data2 <- AG_data [,c("Long_DecimNeg","Lat_DecimNeg")]
head(AG_data2)
tail(AG_data2)

plot(ProPast_tif) 
points(AG_data2)

AG_data2_spdf <- cbind(AG_data2,id= 1:length(AG_data2[,1])) 
head(AG_data2_spdf)
coordinates(AG_data2_spdf) <- c("Long_DecimNeg", "Lat_DecimNeg")  # set spatial coordinates
class(AG_data2_spdf)
AG_data2_spdf@data

proj4string(sta_fe_sptr)
proj4string(AG_data2_spdf)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") 
projection(AG_data2_spdf) <- crs.geo

AG_data2_spdf <- spTransform(AG_data2_spdf, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

AG_data2_stafe <-AG_data2_spdf[!is.na(over(AG_data2_spdf,as(sta_fe_sptr, "SpatialPolygons"))),]
plot(AG_data2_stafe,add=TRUE) #ploteamos el spatial poligons y le adicionamos el spatial points

AG_data2_stafe_extrac<- extract(ProPast_tif,AG_data2_stafe)
head(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac)
AG_data2_stafe_extrac_df <- as.data.frame(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac_df)
class(AG_data2_stafe)
class(AG_data2_stafe@coords) #dentro de un spatial points data frame puedo observar la tabla de atributos con @data o las coordenadas con @coords
coord_df_AG_Past <- as.data.frame(AG_data2_stafe@coords) #con este paso transformamos la matriz de corrdenadas en un data frame
head(coord_df_AG_Past)

data_AG_Past <- cbind(coord_df_AG_Past, AG_data2_stafe_extrac_df) # para unir los data frame de las coordenadas y el de la info de la proporcion de Pastizal

head(data_AG_Past)
tail(data_AG_Past)
head(dataPast_df)

names(dataPast_df)
names(data_AG_Past)

names(dataPast_df)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropPastizal") 
names(data_AG_Past)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropPastizal")


dim(data_AG_Past)
groupP<- rep("pres",504)
head(groupP)
data_AGgruop<- cbind(data_AG_Past,groupP)
names(data_AGgruop)
names(data_AGgruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropPastizal","group")

data_total_Past <- rbind(data_AGgruop, data_bggruop)
head(data_total_Past)
dim(data_total_Past)

boxplot(PropPastizal~group,data=data_total_Past)

save.image("Pastizal.RData")
load("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/Pastizal.RData")

propPastizal<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/propPastizal.csv"
write.table(x = data_total_Past, file= propPastizal, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)
