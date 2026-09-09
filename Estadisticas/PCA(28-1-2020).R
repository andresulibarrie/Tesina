x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
lapply(x, library, character.only = TRUE)

sta_fe<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
sta_fe
plot(sta_fe)

sta_fe_sptr <- spTransform(sta_fe, CRS("+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0 +units=m +no_defs"))
proj4string(sta_fe_sptr)

dire<- "C:/Users/Usuario/Documents/1AGUARATESINA/Variables"
setwd(dire)
getwd()
VarAG = list.files(dire,pattern = '.tif', full.names = TRUE)
VarAG

varAG_stack<- stack(VarAG)
names(varAG_stack)


cultivoCSV<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/propcultivos13-11.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)
bosqueCSV<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/propbosques.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)
pastizalCSV<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/propbosques.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)
distciudadCSV<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/distCd_bgAG.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)
riosCSV<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/riosCSV.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)
distagpermCSV<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/distAgPerm_bgAG.csv", 
                       header = TRUE, sep = ";", 
                       dec = ".", row.names = NULL,
                       as.is = TRUE)
agtempCSV<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/propAguasTemp.csv", 
                         header = TRUE, sep = ";", 
                         dec = ".", row.names = NULL,
                         as.is = TRUE)
rutasCSV <- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/rutasCSV.csv", 
                       header = TRUE, sep = ";", 
                       dec = ".", row.names = NULL,
                       as.is = TRUE)
rutcamautCSV <- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/rutcamautCSV.csv", 
                           header = TRUE, sep = ";", 
                           dec = ".", row.names = NULL,
                           as.is = TRUE)
bios <- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/biosCSV.csv", 
                   header = TRUE, sep = ";", 
                   dec = ".", row.names = NULL,
                   as.is = TRUE)


AGbg<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/presAGbg.csv", 
                  header = TRUE, sep = ";", 
                  dec = ".", row.names = NULL,
                  as.is = TRUE)
head(AGbg)
dim(AGbg)
VarAG_stack_extr<- extract(varAG_stack,AGbg[,2:3])
head(VarAG_stack_extr)
dim(VarAG_stack_extr)

dataAGvar<- cbind(AGbg,VarAG_stack_extr)
head(dataAGvar)
write.table (x = dataAGvar, file= "C:/Users/Usuario/Documents/1AGUARATESINA/Variables/data29-11.csv", append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

library(ggplot2)
library(ggfortify)


prcom<-prcomp(~.-Long_DecimNeg-Lat_DecimNeg-group-rutcamaut-ID, dataAGvar, scale.=T,center=T)
prcom

screeplot(prcom, npcs = 15,type = "lines") #grafico para ver la correlacion de cada eje (PC1,PC2,etc). Cada eje representa una combinacion entre mis variables.

summary(prcom)

autoplot(prcom)
head(dataAGvar)

is.na(dataAGvar)
dataAGvar2<- dataAGvar[complete.cases(dataAGvar),]
dim(dataAGvar)
dim(dataAGvar2)
autoplot(prcom, data = dataAGvar2, colour = 'group')

# tarea: listooo 
ofileNA<- "C:/Users/Usuario/Documents/1AGUARATESINA/0 basesdedatos/data_total_Aguara(c.planas).csv"
write.table(x = dataAGvar2, file= ofileNA, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

dataAGvar <- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/Variables/data29-11.csv", 
           header = TRUE, sep = ";", 
           dec = ".", row.names = NULL,
           as.is = TRUE)

is.na(dataAGvar)
dataAGvar2<- dataAGvar[complete.cases(dataAGvar),]
dim(dataAGvar)
dim(dataAGvar2)


# Passing label = TRUE draws each data label using rownames
autoplot(prcom, data = dataAGvar2, colour = 'group', label = TRUE, label.size = 3)

# Passing shape = FALSE makes plot without points. In this case, label is turned on unless otherwise specified.
autoplot(prcom, data = dataAGvar2, colour = 'group', shape = FALSE, label.size = 3)

# Passing loadings = TRUE draws eigenvectors.
autoplot(prcom, data = dataAGvar2, colour = 'group', loadings = TRUE)

# You can attach eigenvector labels and change some options.
autoplot(prcom, data = dataAGvar2, colour = 'group',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3, frame=TRUE)

prcom0<-prcomp(~.-Long_DecimNeg-Lat_DecimNeg-group-rutas-ID, dataAGvar, scale.=T,center=T)
prcom0
summary(prcom0)
autoplot(prcom0, data = dataAGvar2, colour = 'group',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3, frame=TRUE)

#Ahora repito pero sacando las variables que no son relevantes(EL PUNTO SIGNIFICA TODAS LAS VARIABLES, EXCEPTO...las q van con signo negativo)
prcom2<-prcomp(~.-Long_DecimNeg-Lat_DecimNeg-group-rutcamaut-rutas-ciudad_sync-ID, dataAGvar2, scale.=T,center=T)
prcom2

screeplot(prcom2, npcs = 15,type = "lines")
summary(prcom2)

autoplot(prcom2)

autoplot(prcom2, data = dataAGvar2, colour = 'group', label = TRUE, label.size = 3)
autoplot(prcom2, data = dataAGvar2, colour = 'group', shape = FALSE, label.size = 3)
autoplot(prcom2, data = dataAGvar2, colour = 'group', loadings = TRUE)

autoplot(prcom2, data = dataAGvar2, colour = 'group',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3, frame=TRUE)

prcom3<-prcomp(~C_pl_Bio1+C_pl_Bio10+C_pl_Bio11+C_pl_Bio18+C_pl_Bio16+C_pl_Bio3+C_pl_Bio8+C_pl_Bio9+C_pl_Bio5+C_pl_Bio6+lagperm_sync+ProporcionAguasTempSF+ProporcionCultivos13.11SF+rios, dataAGvar2, scale.=T,center=T)
prcom3

screeplot(prcom3, npcs = 15,type = "lines")
summary(prcom3)

autoplot(prcom3)

autoplot(prcom3, data = dataAGvar2, colour = 'group', label = TRUE, label.size = 3)
autoplot(prcom3, data = dataAGvar2, colour = 'group', shape = FALSE, label.size = 3)
autoplot(prcom3, data = dataAGvar2, colour = 'group', loadings = TRUE)

autoplot(prcom3, data = dataAGvar2, colour = 'group',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3, frame=TRUE)

prcom4<-prcomp(~ciudad_sync+rutcamaut, dataAGvar2, scale.=T,center=T)
prcom4
summary(prcom4)
autoplot(prcom4, data = dataAGvar2, colour = 'group',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3, frame=TRUE)

prcom5<-prcomp(~ciudad_sync+rutas, dataAGvar2, scale.=T,center=T)
prcom5
summary(prcom5)
autoplot(prcom5, data = dataAGvar2, colour = 'group',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3, frame=TRUE)

prcom6<-prcomp(~C_pl_Bio1+C_pl_Bio10+C_pl_Bio11+C_pl_Bio18+C_pl_Bio16+C_pl_Bio3+C_pl_Bio8+C_pl_Bio9+C_pl_Bio5+C_pl_Bio6+lagperm_sync+ProporcionAguasTempSF+ProporcionCultivos13.11SF+rios+ciudad_sync+rutas, dataAGvar2, scale.=T,center=T)
prcom6
summary(prcom6)
autoplot(prcom6, data = dataAGvar2, colour = 'group',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3, frame=TRUE)


prcom7<-prcomp(~ciudad_sync+rutcamaut+C_pl_Bio1+C_pl_Bio10+C_pl_Bio11+C_pl_Bio18+C_pl_Bio16+C_pl_Bio3+C_pl_Bio8+C_pl_Bio9+C_pl_Bio5+C_pl_Bio6+lagperm_sync+ProporcionAguasTempSF+ProporcionCultivos13.11SF+rios, dataAGvar2, scale.=T,center=T)
prcom7
summary(prcom7)
autoplot(prcom7, data = dataAGvar2, colour = 'group',
         loadings = TRUE, loadings.colour = 'blue',
         loadings.label = TRUE, loadings.label.size = 3, frame=TRUE)

#graficas para histogramas

head(dataAGvar2)
dataAGvar2$C_pl_Bio1
#dataAGvar2[dataAGvar2$C_pl_Bio1== "Bio9",]

# ggplot("data.frame con los datos", aes("nombre de la variable que querÃ©s graficar", fill= "nombre de la variable que distingue presencias de background"))...

ggplot(dataAGvar2[,c("C_pl_Bio1","group")], aes(C_pl_Bio1, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.1) + xlab("Temperatura media anual") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio2","group")], aes(C_pl_Bio2, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.1) + xlab("Rango medio diurno") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio3","group")], aes(C_pl_Bio3, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.1) + xlab("isotermalidad") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio4","group")], aes(C_pl_Bio4, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 5) + xlab("Estacionalidad en la temperatura (desv.standard*100)") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio5","group")], aes(C_pl_Bio5, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.1) + xlab("Temp max. del mes más cálido") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio6","group")], aes(C_pl_Bio6, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.3) + xlab("Temp min. del mes más frío") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio7","group")], aes(C_pl_Bio7, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.2) + xlab("Rango anual de temperatura(Bio5-Bio6)") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio8","group")], aes(C_pl_Bio8, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.2) + xlab("Temp media del trimestre más húmedo") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio9","group")], aes(C_pl_Bio9, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.2) + xlab("Temp media del trimestre más seco") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio10","group")], aes(C_pl_Bio10, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.1) + xlab("Temp media del trimestre más cálido") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio11","group")], aes(C_pl_Bio11, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.2) + xlab("Temp media del trimestre más frío") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio12","group")], aes(C_pl_Bio12, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 9) + xlab("Precipitación anual") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio13","group")], aes(C_pl_Bio13, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 2) + xlab("Precipitación del mes más húmedo") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio14","group")], aes(C_pl_Bio14, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 0.6) + xlab("Precipitación del mes más seco") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio15","group")], aes(C_pl_Bio15, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 1) + xlab("Estacionalidad en la precipitación") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio16","group")], aes(C_pl_Bio16, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 3) + xlab("Precipitación del trimestre más húmedo") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio17","group")], aes(C_pl_Bio17, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 2) + xlab("Precipitación del trimestre más seco") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio18","group")], aes(C_pl_Bio18, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 3) + xlab("Precipitación del trimestre más cálido") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("C_pl_Bio19","group")], aes(C_pl_Bio19, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 3) + xlab("Precipitación del trimestre más frio") + ylab("Cantidad de registros")



ggplot(dataAGvar2[,c("ciudad_sync","group")], aes(ciudad_sync, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 3000) + xlab("Distancia a Ciudades") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("lagperm_sync","group")], aes(lagperm_sync, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 3000) + xlab("Distancia a cuerpos de agua permanentes") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("ProporcionAguasTempSF","group")], aes(ProporcionAguasTempSF, fill = group)) + 
 geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 6) + xlab("Proporción  de cuerpos de agua temporales") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("ProporcionCultivos13.11SF","group")], aes(ProporcionCultivos13.11SF, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 5) + xlab("Proporción de cultivos") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("ProporcionPastizalF","group")], aes(ProporcionPastizalF, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 5) + xlab("Proporción de pastizales") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("rios","group")], aes(rios, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 2000) + xlab("Longitud de ríos") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("rutas","group")], aes(rutas, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 1000) + xlab("Longitud de rutas") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("rutcamaut","group")], aes(rutcamaut, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 1300) + xlab("Longitud de rutas y caminos") + ylab("Cantidad de registros")

ggplot(dataAGvar2[,c("ProporcionBosquesSF","group")], aes(ProporcionBosquesSF, fill = group)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 1300) + xlab("Proporcion de bosques") + ylab("Cantidad de registros")


# Fijate que binwidth da cuenta del ancho de las barras
windows()   
ggplot(df[df$BioLayer== "Bio16",c(1,3)], aes(Val, fill = Category)) + 
  geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity') + xlab("Bio16") + ylab("Cantidad de registros")


save.image("PCA.RData")
load("C:/Users/Usuario/Documents/1AGUARATESINA/9 R stuff/ArchivosR/PCA.RData")
