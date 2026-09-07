x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp")
#install.packages(c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp"))
# install.packages(x) # warning: uncommenting this may take a number of minutes
lapply(x, library, character.only = TRUE) # load the required packages

molde<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
laguna<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/shapefiles/LagunaSF_raster.tif")

molde
laguna

molde_rtr <- projectRaster(molde, crs="+proj=tmerc +lat_0=-90 +lon_0=-66 +k=1 +x_0=3500000 +y_0=0 +ellps=WGS84 +units=m +no_defs")
molde_rtr

extent(molde_rtr)
extent(laguna)

plot(extent(molde_rtr))
#plot(extent(laguna), add=TRUE, col="red")
plot(extent(laguna_extend), add=TRUE, col="red")

laguna_extend<- extend (laguna, molde_rtr, value=NA)
laguna_extend
laguna_extend[is.na(laguna_extend[])]<- 0
plot(laguna_extend)

grid_4km <- rasterToPolygons(molde_rtr)
# class(grid_200m)
 plot(grid_4km)

sample_plots<- as(grid_4km, "SpatialPolygons")
class(sample_plots)
str(sample_plots)
#plot(sample_plots)

library(landscapemetrics)
lecos_grid_4km<- sample_lsm(laguna_extend, y = sample_plots, what = "lsm_c_pland") #aca demora
lecos_grid_4km
#class 0= no laguna, class 1 = laguna
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

class_1_r<- rasterize(lecos_grid_4km_cl_1_pland,molde_rtr,field="value")
plot(class_1_r)
class(class_1_r)

writeRaster(x= class_1_r, filename= "ProporcionLagunasSF2", format= "GTiff", bylayer= TRUE, suffix=names(class_1_r))

ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()

PropLag_tiff <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/ProporcionLagunasSF2.tif")
  #list.files(ModisUS,pattern = 'ProporcionLagunasSF', full.names = TRUE)
#class(PropLag_tiff)
#PropLag_tiff_stack <- stack(PropLag_tiff)

#class(PropLag_tiff_stack)
#head(PropLag_tiff_stack)
#plot(PropLag_tiff_stack)

library(dismo)
bgLag <- randomPoints(PropLag_tiff, n=1000) 
plot(bgLag)
proj4string(PropLag_tiff)
points(bgLag)
bgLag
dim(bgLag)
class(bgLag)

bgLag_df <- as.data.frame(bgLag)
plot(bgLag_df)
class(bgLag_df) 

head(bgLag_df)

.rs.unloadPackage("tidyr")

bgLag_df_extrac<- extract(PropLag_tiff,bgLag_df) #aca da error
#Error in UseMethod("extract_") : no applicable method for 'extract_' applied to an object of class "c('RasterStack', 'Raster', 'RasterStackBrick', 'BasicRaster')"

class(bgLag_df_extrac)
bgLag_df_extrac
head(bgLag_df_extrac)
varLag_df <- as.data.frame(bgLag_df_extrac)
head(varLag_df)

dataLag_df<- cbind(bgLag_df,varLag_df)
head(dataLag_df) #hasta aca prepare los comandos

dim(dataLag_df)

boxplot(dataLag_df)

group<- rep("bgr",1000)
head(group) #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado

data_bggruop<- cbind(dataLag_df,group) #cbind une por columnas
#rbind une por filas, hay q hacerlo para cuando uno los puntos del bg y las presencias
head(data_bggruop)
names(data_bggruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distLag","group") #corrigiendo los nombres para que queden tal cual


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/0 basesdedatos/BASE DE DATOS Chrysocyon Santa Fe - completada.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)
#headear = TRUE es para que lea los nombres de las columnas y row names _TRue es para que lea los nombres de las filas
head(data_aguara)
tail(data_aguara)

AG<- data_aguara[,c("Lat_DecimNeg","Long_DecimNeg")] #colnames comando para cambiar los nombres de las columnas
AG_data<- AG[complete.cases(AG),]
AG_data2 <- AG_data [,c("Long_DecimNeg","Lat_DecimNeg")]
head(AG_data2)
tail(AG_data2)

plot(PropLag_tiff) 
points(AG_data2)


AG_data2_spdf <- cbind(AG_data2,id= 1:length(AG_data2[,1])) #como cambiar el id=1,2,3 etc por el id de la base de datos = AGSF_555 ???
head(AG_data2_spdf)
coordinates(AG_data2_spdf) <- c("Long_DecimNeg", "Lat_DecimNeg")  # set spatial coordinates
class(AG_data2_spdf)
AG_data2_spdf@data

sta_fe<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
sta_fe
plot(sta_fe)
# Tabla de atributos
head(sta_fe@data)

proj4string(sta_fe)
proj4string(AG_data2_spdf)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") #para definir la proyeccion exactamente igual a sta_fe (cuando el objeto aun no la tiene)
projection(AG_data2_spdf) <- crs.geo


AG_data2_stafe <-AG_data2_spdf[!is.na(over(AG_data2_spdf,as(sta_fe, "SpatialPolygons"))),]
plot(sta_fe) 
plot(AG_data2_stafe,add=TRUE) #ploteamos el spatial poligons y le adicionamos el spatial points

AG_data2_stafe_extrac<- extract(PropLag_tiff,AG_data2_stafe) #la funcion extract acepta objetos espaciales,data frame, spatial points data frame, entre otros..
head(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac)
AG_data2_stafe_extrac_df <- as.data.frame(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac_df)
class(AG_data2_stafe)
class(AG_data2_stafe@coords) #dentro de un spatial points data frame puedo observar la tabla de atributos con @data o las coordenadas con @coords
coord_df_AG_Lag <- as.data.frame(AG_data2_stafe@coords) #con este paso transformamos la matriz de corrdenadas en un data frame
head(coord_df_AG_Lag)

data_AG_Lag <- cbind(coord_df_AG_Lag, AG_data2_stafe_extrac_df) # para unir los data frame de las coordenadas y el de la info de las distancias a los cuerpos de agua

#la condicion para unir 2 columnas mediante sus filas es necesario que sus nombres sean exactamente iguales, por eso en el proximo paso cambio el nombre de las dos primeras columnas de uno de los objetos
head(data_AG_Lag)
names(dataLag_df)
names(data_AG_Lag)

names(dataLag_df)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropLag") 
names(data_AG_Lag)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropLag")


dim(data_AG_Lag)
groupP<- rep("pres",504)
groupP #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado
data_AGgruop<- cbind(data_AG_Lag,groupP)
names(data_AGgruop)
names(data_AGgruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","PropLag","group") #lo mismo q lo anterior, cambiar los nombres de acuerdo a lo q figure en la variable

data_total_Lag <- rbind(data_AGgruop, data_bggruop)
head(data_total_Lag)
dim(data_total_Lag)

boxplot(PropLag_tiff~group,data=data_total_Lag) #seguramente sea distWB porq van a ser solo dos graficos de caja, asiq solo se ejecuta una funcion

load("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/.RData")
save.image()

ofileWB<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/distWB_bgAG.csv"
write.table(x = data_total_WB, file= ofileWB, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

