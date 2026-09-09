x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
#lapply(x, install.packages, character.only = TRUE)
lapply(x, library, character.only = TRUE)

#install.packages("splancs")
library(splancs) # K-function
#install.packages("smacpod")
#library(smacpod) # Spatial scanning statistic

sta_fe<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")

plot(sta_fe)
sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))


data_aguara<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/0 basesdedatos/BASE DE DATOS Chrysocyon Santa Fe - completada.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)
head(data_aguara)
AG<- data_aguara[,c("Lat_DecimNeg","Long_DecimNeg")] #colnames comando para cambiar los nombres de las columnas
AG_data<- AG[complete.cases(AG),]
AG_data2 <- AG_data [,c("Long_DecimNeg","Lat_DecimNeg")]
head(AG_data2)

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
plot(AG_data2_spdf)#todavia con datos fuera de la provincia
     
AG_data2_stafe <-AG_data2_spdf[!is.na(over(AG_data2_spdf,as(sta_fe_sptr, "SpatialPolygons"))),]
class(AG_data2_stafe ) #ahora corregido
plot(sta_fe_sptr)
plot(AG_data2_stafe,add=T)

#install.packages("polyCub")
library(polyCub)

SP <- as(sta_fe_sptr, "SpatialPolygons")
W <- as(SP, "owin")

W<- as.owin.SpatialPolygons(SP)
# Uniendo lepto_window con lepto_data
# class(casos_lepto_in)

AGdata_ppp<- ppp(AG_data2_stafe@coords[,1], AG_data2_stafe@coords[,2], window = W)
plot(AGdata_ppp)

any(duplicated(AGdata_ppp))
AGdata_ppp_unique_ppp<- unique(AGdata_ppp)


K<-Kest(AGdata_ppp,correction=c("isotropic", "Ripley"))

par(mfrow=c(1,1)) # Plot the estimate of K(r); note different border-corrected estimates ('iso', 'border' and 'trans')
plot(K, xlab="d (dd)", ylab="K(dd)") # Red dashed line is expected K value computed for a CRS process


#E<-envelope(AGdata_ppp, Kest, nsim=100)
E<-envelope(AGdata_ppp, Kest, nsim=999)
plot(E)
