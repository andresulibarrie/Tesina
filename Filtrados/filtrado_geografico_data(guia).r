# Para realizar un filtrado geográfico de los datos.
# Objetivo: balancear la muestra a lo largo de la provincia de Santa Fe
library(dismo)
library(raster)

r <- raster("acá tenés que subir alguno de los rasters que tenés como variable")
fromDisk(r)

# Ahora hay que cambiar la resolución del raster. Esto va a depender de la proyección del raster que estés empleando. Si tu raster está en grados de longitud y latitud, entonces el valor es 0.25 (como se muestra en el ejemplo), pero si está en un plano, la distancia tiene que ser en metros, al así como 25000. Igual siempre verifica con una proyección y podes guardar y subir el raster en qgis y con una regla medir.
r2<- raster(r)
res(r2)<- 0.25

# Siempre estudiar lo que hace la función con ?gridSample
pres_balance_1 <- gridSample(pres, r2, n=1)
head(pres_balance_1)
dim(pres_balance_1)

# Esto repetirlo al menos 10 veces

# Guardar el subset de datos con write.table
