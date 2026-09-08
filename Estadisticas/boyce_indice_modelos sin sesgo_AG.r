# Boyce index

library(ecospat)
install.packages("acepack", type = "source")


raster_maxent2<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus02.asc")

pres<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_2col.csv", 
                   header = TRUE, sep = ";", 
                   dec = ".", row.names = NULL,
                   as.is = TRUE)
head(pres)

boyce_index_pred_2<- ecospat.boyce (fit= raster_maxent2 , obs= pres, nclass=0, window.w="default", res=100, PEplot = TRUE)

raster_maxent3<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus03.asc")

pres3<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_3M.csv", 
                   header = TRUE, sep = ",", 
                   dec = ".", row.names = NULL,
                   as.is = TRUE)
pres3_2col<- pres3[,c(2,3)]

boyce_index_pred_3<- ecospat.boyce (fit= raster_maxent3 , obs= pres3_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_3

raster_maxent4<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus04.asc")

pres4<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_4M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres4_2col<- pres4[,c(2,3)]

boyce_index_pred_4<- ecospat.boyce (fit= raster_maxent4 , obs= pres4_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_4


raster_maxent5<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus05.asc")

pres5<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_5M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres5_2col<- pres5[,c(2,3)]

boyce_index_pred_5<- ecospat.boyce (fit= raster_maxent5 , obs= pres5_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_5

raster_maxent6<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus06.asc")

pres6<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_6M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres6_2col<- pres6[,c(2,3)]

boyce_index_pred_6<- ecospat.boyce (fit= raster_maxent6 , obs= pres6_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_6

raster_maxent7<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus07.asc")

pres7<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_7M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres7_2col<- pres7[,c(2,3)]

boyce_index_pred_7<- ecospat.boyce (fit= raster_maxent7 , obs= pres7_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_7

raster_maxent8<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus08.asc")

pres8<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_8M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres8_2col<- pres8[,c(2,3)]

boyce_index_pred_8<- ecospat.boyce (fit= raster_maxent8 , obs= pres8_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_8

raster_maxent9<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus09.asc")

pres9<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_9M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres9_2col<- pres9[,c(2,3)]

boyce_index_pred_9<- ecospat.boyce (fit= raster_maxent9 , obs= pres9_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_9

raster_maxent10<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus10.asc")

pres10<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado 2/filtro_10M.csv", 
                    header = TRUE, sep = ",", 
                    dec = ".", row.names = NULL,
                    as.is = TRUE)
pres10_2col<- pres10[,c(2,3)]

boyce_index_pred_10<- ecospat.boyce (fit= raster_maxent10 , obs= pres10_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_10

raster_maxent1<- raster("C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent(sin_sesgo)/Todos(ss)/C.brachyurus01.asc")

pres1<- read.table (file="C:/Users/Usuario/Documents/1AGUARATESINA/Filtrado/filtro1_M.csv", 
                     header = TRUE, sep = ",", 
                     dec = ".", row.names = NULL,
                     as.is = TRUE)
pres1_2col<- pres1[,c(2,3)]

boyce_index_pred_1<- ecospat.boyce (fit= raster_maxent1 , obs= pres1_2col, nclass=0, window.w="default", res=100, PEplot = TRUE)
boyce_index_pred_1


