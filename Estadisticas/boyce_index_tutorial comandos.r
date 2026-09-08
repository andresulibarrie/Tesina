# Boyce index
install.packages("ecospat")
library(ecospat)

raster_maxent<- raster("acá tenés que subir el raster ascii que brinda la predicción de maxent con los valores de idoneidad que va desde 0 a 1")

pres<- read.table("acá va la tabla donde tenés los pares de coordenadas para todas las presencias")

# antes de emplear la función preguntar qué hace esta función con: ?ecospat.boyce

boyce_index_pred_1<- ecospat.boyce (fit= raster_maxent , obs= pres, nclass=0, window.w="default", res=100, PEplot = TRUE)

# Leé esta biblio que explica bien el índice:
# Hirzel, A.H., G. Le Lay, V. Helfer, C. Randin and A. Guisan. 2006. Evaluating the ability of habitat
# suitability models to predict species presences. Ecol. Model., 199, 142-152.