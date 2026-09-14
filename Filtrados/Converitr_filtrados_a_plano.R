data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro1.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)

head(data_aguara)

#coords planas("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs")

coordinates(data_aguara) <- c("Longitude", "Latitude")  # set spatial coordinates
class(data_aguara)
data_aguara@data
data_aguara@coords
proj4string(data_aguara)
crs.geo <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0") 
projection(data_aguara) <- crs.geo

data_aguara_spdf <- spTransform(data_aguara, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(data_aguara_spdf)


filtro1<- "C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_1.csv"
write.table(x = data_aguara_spdf, file= filtro1, append = FALSE, quote = FALSE, sep = ",", dec = ".", row.names = T, col.names = T)


data_aguara<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado/filtro2.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro3.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


filtro3<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_3.csv"
write.table(x = data_aguara_spdf, file= filtro3, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro4.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


filtro4<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_4.csv"
write.table(x = data_aguara_spdf, file= filtro4, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro5.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


filtro5<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_5.csv"
write.table(x = data_aguara_spdf, file= filtro5, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro6.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


filtro6<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_6.csv"
write.table(x = data_aguara_spdf, file= filtro6, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)



data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro7.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


filtro7<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_7.csv"
write.table(x = data_aguara_spdf, file= filtro7, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)



data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro8.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


filtro8<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_8.csv"
write.table(x = data_aguara_spdf, file= filtro8, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro9.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


filtro9<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_9.csv"
write.table(x = data_aguara_spdf, file= filtro9, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)


data_aguara<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado/filtro10.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
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


filtro10<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Filtrado 2/filtro_10.csv"
write.table(x = data_aguara_spdf, file= filtro10, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

