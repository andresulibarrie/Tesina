sta_fe<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/SantaFe_plano", "SantaFe_plano")
sta_fe
plot(sta_fe)



data_aguara<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/Base10deJulio/filtro2.2.csv", 
                         header = TRUE, sep = ";", 
                         dec = ",", row.names = NULL,
                         as.is = TRUE)

head(data_aguara)

coordinates(data_aguara) <- c("Longitude", "Latitude")  # set spatial coordinates
class(data_aguara)
data_aguara@data
data_aguara@coords
proj4string(data_aguara)
crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") 
projection(data_aguara) <- crs.geo

data_aguara_spdf <- spTransform(data_aguara, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(data_aguara_spdf)

head(data_aguara_spdf)

filtro2<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_2.csv"
write.table(x = data_aguara_spdf, file= filtro2, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)