install.packages("spThin")
library(spThin)

dataAGbio<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/Variables/data_total_Ag.csv", 
                           header = TRUE, sep = ";", 
                           dec = ".", row.names = NULL,
                           as.is = TRUE)
head(dataAGbio[,2:3])
dim(dataAGbio[,2:3])

dataAGbio[dataAGbio$group=="pres",2:3]

filtro <- thin.algorithm(dataAGbio[dataAGbio$group=="pres",2:3], thin.par= 25, reps= 10)
filtro[[1]]
dim(filtro[[5]])
head(filtro[[2]])
filtrado<- "C:/Users/Usuario/Downloads/1AGUARATESINA/MODIS usos de suelo/filtro2.csv"
write.table(x = filtro[[2]], file= filtrado, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

sta_fe<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/1 primeras cosas/Qgisstuff/DptosSantaFe", "DptosSantaFe")
sta_fe
plot(sta_fe)
points(dataAGbio[dataAGbio$group=="pres",2:3])
points(filtro[[1]],col= "red")

