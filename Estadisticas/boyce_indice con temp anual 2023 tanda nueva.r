
#install.packages("acepack", type = "source")

x <- c("ecospat","raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
lapply(x, library, character.only = TRUE)

#Modelo 1----

raster_maxent1<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus1.asc")

pres<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado/filtro1_2023.csv", 
                   header = TRUE, sep = ";", 
                   dec = ".", row.names = NULL,
                   as.is = TRUE)
head(pres)

boyce_index_pred_1<- ecospat.boyce (fit= raster_maxent1 , obs= pres, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_1$cor
#Modelo 2----
raster_maxent2<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus2.asc")

pres2<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_2M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres2_2col<- pres2[,c(2,3)]

boyce_index_pred_2<- ecospat.boyce (fit= raster_maxent2 , obs= pres2_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_2$cor
#Modelo 3----
raster_maxent3<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus3.asc")

pres3<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_3M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres3_2col<- pres3[,c(2,3)]

boyce_index_pred_3<- ecospat.boyce (fit= raster_maxent3 , obs= pres3_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_3$cor

#Modelo 4----
raster_maxent4<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus4.asc")

pres4<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_4M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres4_2col<- pres4[,c(2,3)]

boyce_index_pred_4<- ecospat.boyce (fit= raster_maxent4 , obs= pres4_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_4$cor

#Modelo 5----
raster_maxent5<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus5.asc")

pres5<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_5M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres5_2col<- pres5[,c(2,3)]

boyce_index_pred_5<- ecospat.boyce (fit= raster_maxent5 , obs= pres5_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_5$cor

#Modelo 6----
raster_maxent6<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus6.asc")

pres6<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_6M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres6_2col<- pres6[,c(2,3)]

boyce_index_pred_6<- ecospat.boyce (fit= raster_maxent6 , obs= pres6_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_6$cor
#Modelo 7----
raster_maxent7<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus7.asc")
pres7<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_7M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres7_2col<- pres7[,c(2,3)]

boyce_index_pred_7<- ecospat.boyce (fit= raster_maxent7 , obs= pres7_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_7$cor
#Modelo 8----
raster_maxent8<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus8.asc")

pres8<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_8M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres8_2col<- pres8[,c(2,3)]

boyce_index_pred_8<- ecospat.boyce (fit= raster_maxent8 , obs= pres8_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_8$cor
#Modelo 9----
raster_maxent9<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus9.asc")

pres9<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_9M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres9_2col<- pres9[,c(2,3)]

boyce_index_pred_9<- ecospat.boyce (fit= raster_maxent9 , obs= pres9_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_9$cor
#Modelo 10----
raster_maxent10<- raster("C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Modelos sin cultivos ENMeval/C.brachyurus10.asc")

pres10<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_10M.csv", 
                     header = TRUE, sep = ",", 
                     dec = ".", row.names = NULL,
                     as.is = TRUE)
pres10_2col<- pres10[,c(2,3)]

boyce_index_pred_10<- ecospat.boyce (fit= raster_maxent10 , obs= pres10_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_10$cor

