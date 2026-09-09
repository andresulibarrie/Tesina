x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "spatstat", "sparr", "sp","ncdf4","dismo")
lapply(x, library, character.only = TRUE)
#install.packages("sdmpredictors")
library(sdmpredictors)

#path<- "C:/Users/Usuario/Downloads/1AGUARATESINA/Modelos Maxent/PruebaPearson"
#setwd(path)
getwd()
files = list.files(path,pattern = '*.asc', full.names = TRUE)
files_stack<- stack(files)

#pearson_correlation_matrix(files_stack, cachesize = 20, same_mask = FALSE)
Pearson_matrix <- pearson_correlation_matrix(files_stack, cachesize = 20, same_mask = FALSE)
dim(Pearson_matrix)

CoefP<- "C:/Users/Usuario/Documents/1AGUARATESINA/MODIS usos de suelo/Maxent 2023/CoeficientesP(todas).csv"
write.table(x = Pearson_matrix, file= CoefP, append = FALSE, quote = FALSE, sep = ";", dec = ".", row.names = T, col.names = T)

#Script Pearson Valor P
mf<- read.table(file="C:/Users/Usuario/Documents/1AGUARATESINA/Modelos Maxent/PruebaPearson/CoeficientesP2.csv", 
                header = TRUE, sep = ";", 
                dec = ".", row.names = NULL,
                as.is = TRUE)
head(mf)
cor.test(~ ascii_C_pl_Bio1 + ascii_ProporcionCultivos13.11SF, data = mf)
