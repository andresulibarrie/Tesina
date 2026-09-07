x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#install.packages(x)
lapply(x, library, character.only = TRUE)

Rios <-  readOGR("C:/Users/Usuario/Downloads/Capas/001_Cursos_De_Agua_StaFe", "001_Cursos_De_Agua_StaFe")
plot(Rios)

sta_fe<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
plot(sta_fe)
# Tabla de atributos
head(sta_fe@data)

proj4string(sta_fe)
proj4string(Rios)

Rios_prj <- spTransform(Rios, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(sta_fe_sptr)
proj4string(Rios_prj)
extent(sta_fe_sptr)
extent(Rios_prj)

plot(Rios_prj)
plot (sta_fe_sptr, add = TRUE)

capas <- "C:/Users/Usuario/Downloads/Capas/Rios_plano"
setwd(capas)
getwd()

writeOGR(Rios_prj, capas, "Rios",driver="ESRI Shapefile")

capas <- "C:/Users/Usuario/Downloads/Capas/SantaFe_plano"
setwd(capas)
getwd()
writeOGR(sta_fe_sptr, capas, "Sta_fe_plano",driver="ESRI Shapefile")

rutas <- readOGR("C:/Users/Usuario/Downloads/Capas/Rutas_stafe", "Rutas_stafe")
plot(rutas)
rutcamaut <- readOGR("C:/Users/Usuario/Downloads/Capas/Rutas_stafe", "RutasCamAut_stafe")
plot(rutcamaut)

proj4string(rutas)
proj4string(rutcamaut)

rutas_prj <- spTransform(rutas, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

rutcamaut_sptr <- spTransform(rutcamaut, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))

proj4string(rutas_prj)
proj4string(rutcamaut_sptr)

capas <- "C:/Users/Usuario/Downloads/Capas/Rutas_stafe_plano"
setwd(capas)
getwd()

writeOGR(rutas_prj, capas, "RutasP",driver="ESRI Shapefile")

capas <- "C:/Users/Usuario/Downloads/Capas/Rutas_stafe_plano"
setwd(capas)
getwd()
writeOGR(rutcamaut_sptr, capas, "RutcamautP",driver="ESRI Shapefile")
#Waterbodies.aggr <- aggregate(Waterbodies, fact = 10, na.rm = TRUE) esta es demasiado

#Ciudad.aggr2 <- aggregate(Ciudad, fact = 2, na.rm = TRUE) #agrandar la resolucion del raster, ene este caso se duplicaron los tamaños de los pixeles
#reproyeccion a metros
#distCd <- distance(Ciudad.aggr2)

distRios <- distance(Rios)
plot(distCd)

distCd_crop <- crop(distCd, sta_fe_sptr)
distCd_crop_mask <- mask(distCd_crop, sta_fe_sptr)
plot(distCd_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distCd_crop_mask, filename= "distCd", format= "GTiff", bylayer= TRUE, suffix=names(distCd_crop_mask))

# una vez que se crea el objeto distWB lo guardo como raster. El mismo va a tener valores de distancia ( a los cuerpos de agua) en cada pixel

distCd_tiff <- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/distCd.tif")
class(distCd_tiff)

#cargar los randompoints
bgCd_df <- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/randompoints.csv", 
                      header = TRUE, sep = ";", 
                      dec = ".", row.names = NULL,
                      as.is = TRUE)
plot(bgCd_df)

bgCd_df_extrac<- extract(distCd_tiff,bgCd_df)
class(bgCd_df_extrac)
bgCd_df_extrac
head(bgCd_df_extrac)
varCd_df <- as.data.frame(bgCd_df_extrac)
head(varCd_df)

dataCd_df<- cbind(bgCd_df,varCd_df)
head(dataCd_df)

dim(dataCd_df)

boxplot(dataCd_df)

group<- rep("bgr",1000)
head(group) #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado

data_bggruop<- cbind(dataCd_df,group) #cbind une por columnas
#rbind une por filas, hay q hacerlo para cuando uno los puntos del bg y las presencias
head(data_bggruop)
names(data_bggruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distCd","group") #corrigiendo los nombres para que queden tal cual


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

plot(distCd_tiff) 
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

AG_data2_stafe_extrac<- extract(distCd_tiff,AG_data2_stafe) #la funcion extract acepta objetos espaciales,data frame, spatial points data frame, entre otros..
head(AG_data2_stafe_extrac)
class(AG_data_stafe_extrac)
AG_data2_stafe_extrac_df <- as.data.frame(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac_df)
class(AG_data2_stafe)
class(AG_data2_stafe@coords) #dentro de un spatial points data frame puedo observar la tabla de atributos con @data o las coordenadas con @coords
coord_df_AG_Cd <- as.data.frame(AG_data2_stafe@coords) #con este paso transformamos la matriz de corrdenadas en un data frame
head(coord_df_AG_Cd)

data_AG_Cd <- cbind(coord_df_AG_Cd, AG_data2_stafe_extrac_df) # para unir los data frame de las coordenadas y el de la info de las distancias a los cuerpos de agua
head(data_AG_Cd)

names(dataCd_df)
names(data_AG_Cd)
names(dataCd_df)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distCd") 
names(data_AG_Cd)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distCd") 
dim(data_AG_Cd)
groupP<- rep("pres",504)
head(groupP) #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado
data_AGgruop<- cbind(data_AG_Cd,groupP)
names(data_AGgruop)
names(data_AGgruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distCd","group") #lo mismo q lo anterior, cambiar los nombres de acuerdo a lo q figure en la variable

data_total_Cd <- rbind(data_AGgruop, data_bggruop)
head(data_total_Cd)
dim(data_total_Cd)

boxplot(distCd~group,data=data_total_Cd) 

#guardar tabla
ofileCd<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/distCd_bgAG.csv"
write.table(x = data_total_Cd, file= ofileCd, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

#guardar archivo con todos los objetos
ArchivosR <- "C:/Users/Usuario/Downloads/1AGUARATESINA/9 R stuff/ArchivosR"
setwd(ArchivosR)
getwd()
save.image("distCd.RData")
#cargarlos
load ("C:/Users/Usuario/Downloads/1AGUARATESINA/9 R stuff/ArchivosR/DistanciaCiudad.RData")
