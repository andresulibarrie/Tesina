# Activamos los paquetes necesarios
x <- c("raster", "rgdal", "rgeos", "maptools", "GISTools", "ncdf4","dismo")
# install.packages(x) # warning: uncommenting this may take a number of minutes
lapply(x, library, character.only = TRUE) # load the required packages

#jueves 31-10
A_pol<- readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/Geoportal/corrientes de agua perenne (pol)_BH140")
plot(A_pol)
A_line<-readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/Geoportal/corrientes de agua perenne (linea)_BH140")
plot(A_line)
Lagu_stafe<-readOGR("C:/Users/Usuario/Downloads/1AGUARATESINA/shapefiles", "laguna_prov") #para cargar los archivos con este patron de nombre
plot(Lagu_stafe)
r<-raster(Lagu_stafe)
r
res(r) <- 500
Lagu_stafe_raster <- rasterize(Lagu_stafe, r, field = "TIPO")
plot(Lagu_stafe_raster)
Lagu_stafe_raster[Lagu_stafe_raster==2] <- 1
writeRaster(x= Lagu_stafe_raster, filename= "LagunaSF_raster", format= "GTiff", bylayer= TRUE, suffix=names(Lagu_stafe_raster))

molde<- raster ("C:/Users/Usuario/Downloads/1AGUARATESINA/Terraclimate/bc_sta_fe_1988_bio6.tif")
molde_sptr <- projectRaster(molde,crs="+proj=tmerc +lat_0=-90 +lon_0=-66 +k=1 +x_0=3500000 +y_0=0 +ellps=WGS84 +units=m +no_defs")

setExtent(x, ext, keepres=FALSE, snap=FALSE) #x el raster al que le quiero cambiar la extension, ext es el que uso de molde para que ambos tengan la misma extencion y keeppres=True es para no modificar la resolucion.
Lagu_stafe_raster_snapT <- setExtent(Lagu_stafe_raster, molde_sptr, keepres=T, snap=T)
Lagu_stafe_raster_snapF <- setExtent(Lagu_stafe_raster, molde_sptr, keepres=T, snap=F)
plot(Lagu_stafe_raster_snapT)

Lagu_stafe_raster_ali<- alignExtent(extent=molde_sptr, object=Lagu_stafe_raster, snap='near')
class(Lagu_stafe_raster_ali)
#aca quedamos craneando...

moldepol<-rasterToPolygons(molde)
proj4string(Lagu_stafe_raster)
proj4string(moldepol)
proj4string(molde_sptr)
moldepol_sptr <- spTransform(moldepol,CRS("+proj=tmerc +lat_0=-90 +lon_0=-66 +k=1 +x_0=3500000 +y_0=0 +ellps=WGS84 +units=m +no_defs")) #para definir la misma proyeccion que Lagu_stafe_raster
proj4string(moldepol_sptr)
class(moldepol_sptr)
head(moldepol_sptr@data)

sample_plots<- as(moldepol_sptr, "SpatialPolygons") #funcion de coercion para pasar de spatial polygons data frame a solo spatial polygons

#install.packages("landscapemetrics")
library(landscapemetrics)
Lagu_stafe_raster
sample_plots
Lagu_stafe_raster[is.na(Lagu_stafe_raster[])] <- 0 #para reemplazar los valores de NA por 0
plot(Lagu_stafe_raster)
plot(sample_plots, add=T)
Lagu_grid_500m<- sample_lsm(Lagu_stafe_raster, y = sample_plots, what = "lsm_c_pland", size = 250)

ArchivosR <- "C:/Users/Usuario/Downloads/1AGUARATESINA/9 R stuff/Archivos.R"
setwd(ArchivosR)
getwd()
save.image()
