Libertad<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/0 basesdedatos/LiberacionesAGcsv2_corregido.csv", 
                        header = TRUE, sep = ";", 
                        dec = ",", row.names = NULL,
                        as.is = TRUE)

head(Libertad)
class(Libertad)

#coords planas("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs")

AG<- Libertad[,c("Latitud","Longitud")] 
AG2 <- AG [,c("Longitud","Latitud")]

AG2_spdf <- cbind(AG2,id= 1:length(AG2[,1])) 
class(AG2_spdf)

#AG2_spdf_c <- AG2_spdf[c("Longitud","Latitud")]  
coordinates(AG2_spdf) <- c("Longitud","Latitud")  
class(AG2_spdf)
AG2_spdf@data

proj4string(AG2_spdf)

crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") 
projection(AG2_spdf) <- crs.geo

Libertad_spdf <- spTransform(AG2_spdf, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(Libertad_spdf)


Liberaciones2<- "C:/Users/Usuario/Documents/1AGUARATESINA/0 basesdedatos/LiberacionesPlanas2_corregidas.csv"
write.table(x = Libertad_spdf, file= Liberaciones2, append = FALSE, quote = FALSE, sep = ";", dec = ",", row.names = T, col.names = T)
