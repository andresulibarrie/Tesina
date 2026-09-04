# hoy es viernes 25- 10 - 2019 y estoy con mi amigo maxi empezando de vuelta

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

Landuse18_prj <- projectRaster(Landuse18, crs= "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",method = "ngb") #se le agrega ngb xq al ser variables categoricas no nos sirve la que es por defecto (un promedio de los dos tipos de clases) sino que necesitamos una sola categoria (un nro entero) con este metodo por lo tanto se selecciona una caterogira (la que predomina)
proj4string(Landuse18_prj)
getValues(Landuse18_prj)
unique(getValues(Landuse18_prj))
class(sta_fe)
#sta_fe_prj <- spTransform (sta_fe, CRS =  "+proj=sinu +lon_0=0 +x_0=0 +y_0=0 +a=6371007.181 +b=6371007.181 +units=m +no_defs")
#proj4string(sta_fe_prj)

plot(Landuse18_prj)
plot (sta_fe, add = TRUE)

Landuse18_prj_crop <- crop(Landuse18_prj, sta_fe)
Landuse18_prj_crop_mask <- mask(Landuse18_prj_crop, sta_fe)
plot(Landuse18_prj_crop_mask)
getValues(Landuse18_prj_crop_mask)
class(getValues(Landuse18_prj_crop_mask))

vectorLAND <- getValues(Landuse18_prj_crop_mask)
unique(vectorLAND)

Cultivo <- Landuse18_prj_crop_mask
Cultivo [Cultivo < 12] <- NA
Cultivo [Cultivo > 14] <- NA
Cultivo [Cultivo == 13] <- NA
plot(Cultivo)

Cultivo [Cultivo == 12] <- 14

Pastizal <- Landuse18_prj_crop_mask
Pastizal [Pastizal < 10] <- NA
Pastizal [Pastizal > 10] <- NA
plot (Pastizal)

Bosque <- Landuse18_prj_crop_mask
Bosque [Bosque > 5] <- NA
#Bosque [Bosque == 1] <- NA
plot(Bosque)

Arbustos <- Landuse18_prj_crop_mask
Arbustos [Arbustos < 7] <- NA
Arbustos [Arbustos > 7] <- NA
plot (Arbustos)

Savanas<- Landuse18_prj_crop_mask
Savanas [Savanas< 8] <- NA
Savanas [Savanas > 9] <- NA
plot (Savanas)

BosquesySavanas<- Landuse18_prj_crop_mask
BosquesySavanas [BosquesySavanas > 9] <- NA
plot (BosquesySavanas)

Ciudad<- Landuse18_prj_crop_mask
Ciudad [Ciudad< 13] <- NA
Ciudad [Ciudad > 13] <- NA
plot (Ciudad)

SueloDesc<- Landuse18_prj_crop_mask
SueloDesc[SueloDesc< 16] <- NA
SueloDesc [SueloDesc> 16] <- NA
plot (SueloDesc)

#Agrupar categorias:
# 1 Bosque (1-5) o Bosque y sabanas (1-9) Hacer proporcion
# 2 Pastizal 10 Hacer proporcion
# 3 Cuerpos de agua (11,17 y shp de lagunas) Hacer distancia a
# 4 Cultivos (12 y 14) mas del 50% de tierra cultivada Hacer proporcion
# 5 Urbanizacion (13) Hacer distancia a

#tarea proporcion de cultivos
#prop de pastizales, y si se puede sabana
#dist a ciudades



distWB <- distance(Waterbodies)

load("C:/Users/Usuario/Documents/.RData")
load()
save.image()
getwd()
#Waterbodies.aggr <- aggregate(Waterbodies, fact = 10, na.rm = TRUE) esta es demasiado
Waterbodies.aggr2 <- aggregate(Waterbodies, fact = 2, na.rm = TRUE) #agrandar la resolucion del raster, ene este caso se duplicaron los tamaños de los pixeles
plot(Waterbodies.aggr2)
#reproyeccion a metros

distWB <- distance(Waterbodies.aggr2)
plot(distWB)

distWB_crop <- crop(distWB, sta_fe)
distWB_crop_mask <- mask(distWB_crop, sta_fe)
plot(distWB_crop_mask)
ModisUS <- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo"
setwd(ModisUS)
getwd()
writeRaster(x= distWB_crop_mask, filename= "distWB", format= "GTiff", bylayer= TRUE, suffix=names(distWB_crop_mask))

# una vez que se crea el objeto distWB lo guardo como raster. El mismo va a tener valores de distancia ( a los cuerpos de agua) en cada pixel, tengo q hacer entonces lo mismo q hice para las otras variables -> hacer una tabla con los datos de presencia y otra con los bgr. y a cada una agregarle los datos de distancia. Despues graficar los boxplot. Uno para las bgr y otro para las presencias.


distWB_tiff <- list.files(ModisUS,pattern = 'distWB', full.names = TRUE)
class(distWB_tiff)
distWB_tiff_stack <- stack(distWB_tiff)

class(distWB_tiff_stack)
head(distWB_tiff_stack)
plot(distWB_tiff_stack)

bgWB <- randomPoints(distWB_tiff_stack, n=1000) 
plot(bgWB)
proj4string(distWB_crop_mask)
points(bgWB)
bgWB
dim(bgWB)
class(bgWB)

bgWB_df <- as.data.frame(bgWB)
plot(bgWB_df)
#ModisUS <- #ya esta definido mas arriba
  #WB_bg = list.files(ModisUS,pattern = 'distWB', full.names = TRUE)
  #WB_bg
  
  #WB_bg_stack <- stack(WB_bg)
  
bgWB_df_extrac<- extract(distWB_tiff_stack,bgWB_df)
class(bgWB_df_extrac)
bgWB_df_extrac
head(bgWB_df_extrac)
varWB_df <- as.data.frame(bgWB_df_extrac)
head(varWB_df)

dataWB_df<- cbind(bgWB_df,varWB_df)
head(dataWB_df)

dim(dataWB_df)

boxplot(dataWB_df)

group<- rep("bgr",1000)
group #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado

data_bggruop<- cbind(dataWB_df,group) #cbind une por columnas
#rbind une por filas, hay q hacerlo para cuando uno los puntos del bg y las presencias
head(data_bggruop)
names(data_bggruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distWB","group") #corrigiendo los nombres para que queden tal cual


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

plot(distWB_tiff_stack) 
points(AG_data2)


AG_data2_spdf <- cbind(AG_data2,id= 1:length(AG_data2[,1])) #como cambiar el id=1,2,3 etc por el id de la base de datos = AGSF_555 ???
head(AG_data2_spdf)
coordinates(AG_data2_spdf) <- c("Long_DecimNeg", "Lat_DecimNeg")  # set spatial coordinates
class(AG_data2_spdf)
AG_data2_spdf@data

proj4string(sta_fe)
proj4string(AG_data2_spdf)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") #para definir la proyeccion exactamente igual a sta_fe (cuando el objeto aun no la tiene)
projection(AG_data2_spdf) <- crs.geo


AG_data2_stafe <-AG_data2_spdf[!is.na(over(AG_data2_spdf,as(sta_fe, "SpatialPolygons"))),]
plot(sta_fe) 
plot(AG_data2_stafe,add=TRUE) #ploteamos el spatial poligons y le adicionamos el spatial points

AG_data2_stafe_extrac<- extract(distWB_tiff_stack,AG_data2_stafe) #la funcion extract acepta objetos espaciales,data frame, spatial points data frame, entre otros..
head(AG_data2_stafe_extrac)
class(AG_data_stafe_extrac)
AG_data2_stafe_extrac_df <- as.data.frame(AG_data2_stafe_extrac)
class(AG_data2_stafe_extrac_df)
class(AG_data2_stafe)
class(AG_data2_stafe@coords) #dentro de un spatial points data frame puedo observar la tabla de atributos con @data o las coordenadas con @coords
coord_df_AG_WB <- as.data.frame(AG_data2_stafe@coords) #con este paso transformamos la matriz de corrdenadas en un data frame
head(coord_df_AG_WB)

data_AG_WB <- cbind(coord_df_AG_WB, AG_data2_stafe_extrac_df) # para unir los data frame de las coordenadas y el de la info de las distancias a los cuerpos de agua

#la condicion para unir 2 columnas mediante sus filas es necesario que sus nombres sean exactamente iguales, por eso en el proximo paso cambio el nombre de las dos primeras columnas de uno de los objetos

names(dataWB_df)
names(data_AG_WB)
names(dataWB_df)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distWB") #para cambiar los nombres de las columnas para que queden iguales a data_AG_WB

#-------------todo esto en teoria ya lo hice, corroborar--------------
group<- rep("bgr",1000)
group #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado

data_bggruop<- cbind(data,group) #cbind une por columnas
#rbind une por filas, hay q hacerlo para cuando uno los puntos del bg y las presencias
head(data_bggruop)
#-------------todo esto en teoria ya lo hice, corroborar--------------

dim(data_AG_WB)
groupP<- rep("pres",504)
groupP #en el caso de las presencias, en lugar de "bgr" escribir "presencias" o algo abreviado
data_AGgruop<- cbind(data_AG_WB,groupP)
names(data_AGgruop)
names(data_AGgruop)<- c("Long_DecimNeg" ,"Lat_DecimNeg","distWB","group") #lo mismo q lo anterior, cambiar los nombres de acuerdo a lo q figure en la variable

data_total_WB <- rbind(data_AGgruop, data_bggruop)
head(data_total_WB)
dim(data_total_WB)

boxplot(distWB~group,data=data_total_WB) #seguramente sea distWB porq van a ser solo dos graficos de caja, asiq solo se ejecuta una funcion

load("C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/.RData")
save.image()

ofileWB<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/distWB_bgAG.csv"
write.table(x = data_total_WB, file= ofileWB, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)