rios<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/rios.tif")
rutas<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/rutas.tif")
rutcamaut<- raster("C:/Users/Usuario/Downloads/1AGUARATESINA/Variables/rutcamaut.tif")

AGbgCSV<- read.table(file="C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/presAGybg.csv", 
                      header = TRUE, sep = ";", 
                      dec = ".", row.names = NULL,
                      as.is = TRUE)
plot(rios)
head(rios@data)

rios_extrac<- extract(rios,AGbgCSV[,2:3]) #indexar: cuando selecciono columnas dentro de una tabla
rios_extrac[1000]
rios_extrac[600]
head(rios_extrac)
datarios<- cbind(AGbgCSV, rios_extrac)
head(datarios)
datarios2<- datarios[,c("ID","Long_DecimNeg","Lat_DecimNeg","rios_extrac","group")]
head(datarios2)
names(datarios2)<- c("ID","Long_DecimNeg" ,"Lat_DecimNeg","rios","group")

riosCSV<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/riosCSV.csv"
write.table(x = datarios2, file= riosCSV, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

rutas_extrac<- extract(rutas,AGbgCSV[,2:3]) #indexar: cuando selecciono columnas dentro de una tabla
rutas_extrac[1000]
rutas_extrac[600]
head(rutas_extrac)
datarutas<- cbind(AGbgCSV, rutas_extrac)
head(datarutas)
datarutas2<- datarutas[,c("ID","Long_DecimNeg","Lat_DecimNeg","rutas_extrac","group")]
head(datarutas2)
names(datarutas2)<- c("ID","Long_DecimNeg" ,"Lat_DecimNeg","rutas","group")

rutasCSV<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/rutasCSV.csv"
write.table(x = datarutas2, file= rutasCSV, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

rutcamaut_extrac<- extract(rutcamaut,AGbgCSV[,2:3]) #indexar: cuando selecciono columnas dentro de una tabla
rutcamaut_extrac[1000]
rutcamaut_extrac[600]
head(rutcamaut_extrac)
datarutcamaut<- cbind(AGbgCSV, rutcamaut_extrac)
head(datarutcamaut)
datarutcamaut2<- datarutcamaut[,c("ID","Long_DecimNeg","Lat_DecimNeg","rutcamaut_extrac","group")]
head(datarutcamaut2)
names(datarutcamaut2)<- c("ID","Long_DecimNeg" ,"Lat_DecimNeg","rutcamaut","group")

rutcamautCSV<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/rutcamautCSV.csv"
write.table(x = datarutcamaut2, file= rutcamautCSV, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)
