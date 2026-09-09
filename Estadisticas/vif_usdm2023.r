# Anliazar la colinealidad de las variables ambientales
# A partir del factor de inflación de varianza (VIF)
install.packages("usdm")
library(usdm)

# subir los directorios
files <- list.files(pattern = '.tif', full.names = TRUE)

filesr <- stack(files) 

# Para entender lo que realiza la siguiente función, consultar el pdf del paquete
?vifcor
?vifstep
vif(filesr) # calculates vif for the variables in r

v1 <- vifcor(filesr, th=0.7) # identify collinear variables that should be excluded
v1

v2 <- vifstep(filesr, th=5) # identify collinear variables that should be excluded
v2
