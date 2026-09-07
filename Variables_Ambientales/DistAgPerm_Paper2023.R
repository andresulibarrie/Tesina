x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages(x)
lapply(x, library, character.only = TRUE)

#save.image("AguasPerm.RData")

sta_fe<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
sta_fe
plot(sta_fe)
# Tabla de atributos
head(sta_fe@data)

AguasPerm<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Usosdesuelo/Cuerpos_de_Agua_prov", "cuerpos_de_agua_prov_perm")
plot(AguasPerm)
head(AguasPerm@data)

proj4string(sta_fe)
proj4string(AguasPerm)
install.packages("rgdal", repos="R-Forge.R-project.org")
#rgdal::set_proj_search_paths("C:/Users/Usuario/Documents/R/win-library/4.0/rgdal/proj")

sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs"))
proj4string(sta_fe_sptr)
extent(sta_fe_sptr)

AguasPerm_sptr <- spTransform(AguasPerm, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
class(sta_fe_sptr)

proj4string(sta_fe)
proj4string(AguasPerm)

plot(AguasPerm)
plot (sta_fe, add = TRUE)
extent(sta_fe)
extent(AguasPerm)

r<-raster(sta_fe)
r
res(r) <- 500
AguasPerm_raster <- rasterize(AguasPerm, r, field = "TIPO")
plot(AguasPerm_raster)
AguasPerm_raster[AguasPerm_raster==2] <- 1

writeRaster(x= AguasPerm_sptr_raster, filename= "AguasPermSF_raster", format= "GTiff", bylayer= TRUE, suffix=names(AguasPerm_sptr_raster))

AguasPermRaster<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Landuse cada 5 años/AguasPermSF.tif")
proj4string(AguasPermRaster)
extent(AguasPermRaster)

distAgPerm <- distance(AguasPermRaster)
plot(distAgPerm)
plot (sta_fe, add = TRUE)

extent(distAgPerm)

distAgPerm_crop <- crop(distAgPerm, sta_fe)
distAgPerm_crop_mask <- mask(distAgPerm_crop, sta_fe_sptr)
plot(distAgPerm_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distAgPerm_crop_mask, filename= "distAgPerm", format= "GTiff", bylayer= TRUE, suffix=names(distAgPerm_crop_mask))

distAgPerm_tiff <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/distAgPerm.tif")
class(distAgPerm_tiff)

#cargar los randompoints
bgAgPerm_df <- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/randompoints.csv", 
                      header = TRUE, sep = ";", 
                      dec = ".", row.names = NULL,
                      as.is = TRUE)
plot(bgAgPerm_df)

bgAgPerm_df_extrac<- extract(distAgPerm_tiff,bgAgPerm_df)
class(bgAgPerm_df_extrac)
bgAgPerm_df_extrac
head(bgAgPerm_df_extrac)
varAgPerm_df <- as.data.frame(bgAgPerm_df_extrac)
head(varAgPerm_df)

dataAgPerm_df<- cbind(bgAgPerm_df,varAgPerm_df)
head(dataAgPerm_df)

dim(dataAgPerm_df)

boxplot(dataAgPerm_df)

group<- rep("bgr",1000)
head(group) #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado

data_bggruop<- cbind(dataAgPerm_df,group) #cbind une por columnas
#rbind une por filas, hay q hacerlo para cuando uno los puntos del bg y las presencias
head(data_bggruop)
names(data_bggruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distAgPerm","group") #corrigiendo los nombres para que queden tal cual


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

plot(distAgPerm_tiff) 
points(AG_data2)

AG_data2_spdf <- cbind(AG_data2,id= 1:length(AG_data2[,1])) #como cambiar el id=1,2,3 etc por el id de la base de datos = AGSF_555 ???
head(AG_data2_spdf)
coordinates(AG_data2_spdf) <- c("Long_DecimNeg", "Lat_DecimNeg")  # set spatial coordinates
class(AG_data2_spdf)
head(AG_data2_spdf@data)

proj4string(sta_fe_sptr)
proj4string(AG_data2_spdf)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") #para definir la proyeccion exactamente igual a sta_fe (cuando el objeto aun no la tiene)
projection(AG_data2_spdf) <- crs.geo

AG_data2_spdf <- spTransform(AG_data2_spdf, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(AG_data2_spdf)

AG_data2_stafe <-AG_data2_spdf[!is.na(over(AG_data2_spdf,as(sta_fe_sptr, "SpatialPolygons"))),]
plot(sta_fe_sptr) 
plot(AG_data2_stafe,add=TRUE) #ploteamos el spatial poligons y le adicionamos el spatial points

AG_data2_stafe_extrac<- extract(distAgPerm_tiff,AG_data2_stafe) #la funcion extract acepta objetos espaciales,data frame, spatial points data frame, entre otros..
head(AG_data2_stafe_extrac)
class(AG_data_stafe_extrac)
AG_data2_stafe_extrac_df <- as.data.frame(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac_df)
class(AG_data2_stafe)
class(AG_data2_stafe@coords) #dentro de un spatial points data frame puedo observar la tabla de atributos con @data o las coordenadas con @coords
coord_df_AG_AgPerm <- as.data.frame(AG_data2_stafe@coords) #con este paso transformamos la matriz de corrdenadas en un data frame
head(coord_df_AG_AgPerm)

data_AG_AgPerm <- cbind(coord_df_AG_AgPerm, AG_data2_stafe_extrac_df) # para unir los data frame de las coordenadas y el de la info de las distancias a los cuerpos de agua
head(data_AG_AgPerm)

names(dataAgPerm_df)
names(data_AG_AgPerm)
names(dataAgPerm_df)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distAgPerm") 
names(data_AG_AgPerm)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distAgPerm") 
dim(data_AG_AgPerm)
groupP<- rep("pres",504)
head(groupP) #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado
data_AGgruop<- cbind(data_AG_AgPerm,groupP)
names(data_AGgruop)
names(data_AGgruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distAgPerm","group") #lo mismo q lo anterior, cambiar los nombres de acuerdo a lo q figure en la variable

data_total_AgPerm <- rbind(data_AGgruop, data_bggruop)
head(data_total_AgPerm)
dim(data_total_AgPerm)

boxplot(distAgPerm~group,data=data_total_AgPerm) 

#guardar tabla
ofileAgPerm<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/distAgPerm_bgAG.csv"
write.table(x = data_total_AgPerm, file= ofileAgPerm, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

#guardar archivo con todos los objetos
ArchivosR <- "C:/Users/Usuario/Downloads/1AGUARATESINA/9 R stuff/ArchivosR"
setwd(ArchivosR)
getwd()
save.image("distAgPerm.RData")
#cargarlos
load ("C:/Users/Usuario/Downloads/1AGUARATESINA/9 R stuff/ArchivosR/DistanciaCiudad.RData")

