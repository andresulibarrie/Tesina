library(spatial.tools)

windows()

vardir<- "C:/Users/Usuario/Downloads/2023 Trabajos/Paper tesina 2023/Comandos de maxent R/Archivos para modelos/Kernel aguara"
setwd(vardir)
getwd()
files <- list.files(vardir,pattern = '.tif', full.names = TRUE)
var<-stack(files) 

names(var)
var_res<- projectRaster(var, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +units=m +no_defs",method = "ngb",res = 4295)

writeRaster(x= var_res, filename= "ascii", format= "ascii", bylayer= TRUE, suffix=names(var_res))


            