x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages(x)
lapply(x, library, character.only = TRUE)

save.image("AguasTemp.RData")

sta_fe<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
sta_fe
plot(sta_fe)
# Tabla de atributos
head(sta_fe@data)

sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(sta_fe_sptr)

AguasTemp<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/Usosdesuelo/Cuerpos_de_Agua_prov", "cuerpos_de_agua_prov_no_perm")
plot(AguasTemp)
head(AguasTemp@data)

proj4string(sta_fe_sptr)
proj4string(AguasTemp)

AguasTemp_sptr <- spTransform(AguasTemp, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(AguasTemp_sptr)

plot(AguasTemp_sptr)
plot (sta_fe_sptr, add = TRUE)

extent(sta_fe_sptr)
extent(AguasTemp_sptr)
head(AguasTemp_sptr@data)

molde<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")

molde
AguasTemp_sptr

plot(AguasTemp_sptr)
r<-raster(AguasTemp_sptr)
r
res(r) <- 500
AguasTemp_sptr_raster <- rasterize(AguasTemp_sptr, r, field = "TIPO")
plot(AguasTemp_sptr_raster)
AguasTemp_sptr_raster[AguasTemp_sptr_raster==2] <- 1
AguasTemp_sptr_raster[AguasTemp_sptr_raster==3] <- 1
AguasTemp_sptr_raster[AguasTemp_sptr_raster==4] <- 1

writeRaster(x= AguasTemp_sptr_raster, filename= "AguasTempSF_raster", format= "GTiff", bylayer= TRUE, suffix=names(AguasTemp_sptr_raster))

molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs",method = "ngb")
molde_rtr

extent(molde_rtr)
extent(AguasTemp_sptr_raster)

plot(extent(molde_rtr))
plot(extent(AguasTemp_sptr_raster), add=TRUE, col="red")

AguaTemp_extend<- extend (AguasTemp_sptr_raster, molde_rtr, value=NA)
AguaTemp_extend
plot(extent(AguaTemp_extend), add=TRUE, col="red")
AguaTemp_extend[is.na(AguaTemp_extend[])]<- 0
plot(AguaTemp_extend)
extent(AguaTemp_extend)

grid_4km <- rasterToPolygons(molde_rtr)
plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)
str(sample_plots)

library(landscapemetrics)
lecos_grid_4km<- sample_lsm(AguaTemp_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
tail(lecos_grid_4km)
head(lecos_grid_4km)

library(tidyverse)
cl_1_pland<- filter(lecos_grid_4km, class == 1, metric== "pland")

rownames(cl_1_pland)

cl_1_pland_df<- as.data.frame(cl_1_pland)

class(cl_1_pland_df)
head(cl_1_pland_df)
rownames(cl_1_pland_df)<- cl_1_pland_df[,"plot_id"]

df_plot_id<- data.frame(plot_id=as.numeric(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))), number=1:length(sapply(slot(grid_4km, "polygons"), function(x) slot(x, "ID"))))

library(dplyr)
head(df_plot_id)
tail(df_plot_id)
class(df_plot_id$plot_id)

class_1<- full_join(df_plot_id,cl_1_pland_df, by = "plot_id")
class_1[is.na(class_1)] <- 0

lecos_grid_4km_cl_1_pland<- spCbind(grid_4km, class_1)
head(lecos_grid_4km_cl_1_pland@data)
tail(lecos_grid_4km_cl_1_pland@data)
class_1_r<- rasterize(lecos_grid_4km_cl_1_pland,molde_rtr,field="value")
plot(class_1_r)
class(class_1_r)

writeRaster(x= class_1_r, filename= "ProporcionAguasTempSF", format= "GTiff", bylayer= TRUE, suffix=names(class_1_r))

extent(class_1_r)

#segunda parte
#comparar con datos de presencia y con la muestra representativa

ProAgtemp_tif <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/ProporcionAguasTempSF.tif")
plot(ProAgtemp_tif)

library(dismo)
bgAgtemp<- read.table (file="C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/randompoints.csv",                        
                        header = TRUE, sep = ";", 
                        dec = ".", row.names = NULL,
                        as.is = TRUE)
plot(bgAgtemp)
class(bgAgtemp) 

bgAgtemp_df <- as.data.frame(bgAgtemp)
plot(bgAgtemp_df)
class(bgAgtemp_df) 
head(bgAgtemp_df)

.rs.unloadPackage("tidyr")

bgAgtemp_df_extrac<- extract(ProAgtemp_tif,bgAgtemp_df) #aca da error si no desactivo el paquete tidyr

class(bgAgtemp_df_extrac)
head(bgAgtemp_df_extrac)
varAgTemp_df <- as.data.frame(bgAgtemp_df_extrac)
head(varAgTemp_df)

dataAgTemp_df<- cbind(bgAgtemp_df,varAgTemp_df)
head(dataAgTemp_df)
boxplot(dataAgTemp_df)

group<- rep("bgr",1000)
head(group) 

data_bggruop<- cbind(dataAgTemp_df,group) #cbind une por columnas
head(data_bggruop)
names(data_bggruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropAguasTemp","group")


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/0 basesdedatos/BASE DE DATOS Chrysocyon Santa Fe - completada.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)

AG<- data_aguara[,c("Lat_DecimNeg","Long_DecimNeg")] #colnames comando para cambiar los nombres de las columnas
AG_data<- AG[complete.cases(AG),]
AG_data2 <- AG_data [,c("Long_DecimNeg","Lat_DecimNeg")]
head(AG_data2)
tail(AG_data2)

plot(ProAgtemp_tif) 
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

AG_data2_stafe_extrac<- extract(ProAgtemp_tif,AG_data2_stafe)
head(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac)
AG_data2_stafe_extrac_df <- as.data.frame(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac_df)
class(AG_data2_stafe)
class(AG_data2_stafe@coords) #dentro de un spatial points data frame puedo observar la tabla de atributos con @data o las coordenadas con @coords
coord_df_AG_AgTemp <- as.data.frame(AG_data2_stafe@coords) #con este paso transformamos la matriz de corrdenadas en un data frame
head(coord_df_AG_AgTemp)

data_AG_AgTemp <- cbind(coord_df_AG_AgTemp, AG_data2_stafe_extrac_df) 

head(data_AG_AgTemp)
tail(data_AG_AgTemp)
head(dataAgTemp_df)

names(dataAgTemp_df)
names(data_AG_AgTemp)

names(dataAgTemp_df)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropAguasTemp") 
names(data_AG_AgTemp)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropAguasTemp")


dim(data_AG_AgTemp)
groupP<- rep("pres",504)
head(groupP)
data_AGgruop<- cbind(data_AG_AgTemp,groupP)
names(data_AGgruop)
names(data_AGgruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropAguasTemp","group")

data_total_AgTemp <- rbind(data_AGgruop, data_bggruop)
tail(data_total_AgTemp)
dim(data_total_AgTemp)

boxplot(PropAguasTemp~group,data=data_total_AgTemp)

#hist() como era la funcion histograma

load("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/.RData")
save.image("AguasTemp.RData")

propAgTemp<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/propAguasTemp.csv"
write.table(x = data_total_AgTemp, file= propAgTemp, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)
