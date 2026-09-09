# install.packages(c("rJava","dismo"))

# library("rJava")
library("dismo")
library("raster")

# system.file("java", package="dismo")

# options(java.parameters = "-Xmx1g" )

# files <- c( "bio2.tif", "bio7.tif", "bio8.tif", "bio13.tif", 
            # "bio15.tif", "bio17.tif")
# files <- paste("./spatial_data",files,sep="/")

files<- list.files (path= "F:/VariablesAG", pattern= "Bio", full.names= TRUE)
bio_layers <- stack(files)
proj4string(bio_layers)
# [1] "+proj=longlat +ellps=WGS84 +no_defs"
bio_layers <- projectRaster(bio_layers, crs="+proj=tmerc +lat_0=-90 +lon_0=-60 +k=1 +x_0=5500000 +y_0=0 +ellps=GRS80 +towgs84=0")

sites <- read.csv("F:/VariablesAG/AGpoints.csv",header=TRUE, sep=";")
head(sites)
dim(sites)
# sites <- read.csv("./spatial_data/EuphorbiaAllLocations.csv",header=TRUE)

# num_train <- round(nrow(sites)*.8)

# idx <- sample( 1:nrow(sites), size=nrow(sites), replace=FALSE )
# pts.train <- sites[ idx[1:num_train] , 2:3]
# pts.test <- sites[ idx[ (num_train+1):length(idx)], 2:3]
# c( Train=nrow(pts.train), Test=nrow(pts.test) )

# fit <- maxent(bio_layers,pts.train)

# plot(fit)

# response(fit)

# r <- predict( fit, bio_layers )
# plot(r, xlab="Longitude",ylab="Latitude")
# points( pts.train, pch=3, cex=0.75)
# points( pts.train, pch=16, cex=0.75)

pts.random <- randomPoints(bio_layers, 1000)
# fit.eval <- evaluate(fit, p=pts.test, a=pts.random, x=bio_layers)
# fit.eval

# vals.pred <- data.frame( extract( bio_layers, pts.test) )
# vals.rand <- data.frame( extract( bio_layers, pts.random) )
# fit.eval_rnd <- evaluate(fit, p=vals.pred, a=vals.rand)
# fit.eval_rnd

library(ggplot2)

df <- data.frame( Val=NA, BioLayer=NA, Category=NA )
head(df)

pts.pres <- sites[,2:3]

# vals.pred <- data.frame( extract( bio_layers, pts.test) )
vals.pred <- data.frame( extract( bio_layers, pts.pres) )
vals.rand <- data.frame( extract( bio_layers, pts.random) )
class(vals.pred)
head(vals.pred)

layers <- names(vals.pred)
layers

for( layer in layers){
  Val <- c( vals.pred[[layer]], vals.rand[[layer]] )
  Category <- c( rep("Observed",nrow(vals.pred)), rep("Background",nrow(vals.rand)))
  df <- rbind( df, data.frame( Val, BioLayer=layer, Category))
}

head(df)
# Acá es donde elegís qué variables representar, fijate que es la posición del raster dentro del stack, asi que el número no necesariamente corresponde con el número de la variable, como BIO1...
# df$BioLayer <- factor( df$BioLayer, ordered=TRUE, 
                       # levels = names(vals.pred)[c(1,2,5,6,3,4)])

# df$BioLayer <- factor( df$BioLayer, ordered=TRUE, 
                       # levels = names(vals.pred)[c(1,2,3)])

# df$BioLayer <- factor( df$BioLayer, ordered=TRUE, 
                       # levels = names(vals.pred)[c(4,5,6)])
 # df$BioLayer <- factor( df$BioLayer, ordered=TRUE, 
                        # levels = names(vals.pred)[c(7,8,9)])
# df$BioLayer <- factor( df$BioLayer, ordered=TRUE, 
                        # levels = names(vals.pred)[c(10,11,12)])
# df$BioLayer <- factor( df$BioLayer, ordered=TRUE, 
                        # levels = names(vals.pred)[c(13,14,15)])

df$BioLayer <- factor( df$BioLayer, ordered=TRUE, 
                        levels = names(vals.pred)[c(16,17,18,19)])
						
df$Category <- factor( df$Category )
df <- df[ !is.na(df$Val),]

p <- ggplot(df,aes(x=Val, fill=Category)) + geom_density(alpha=0.75)  
p <- p + facet_wrap(~BioLayer, nrow=3, scale="free") 
p <- p + scale_fill_brewer(type="qual",palette=3) 
p + xlab("Biolayer Value") + ylab("Density") 



# Ejemplo
carrots <- data.frame(length = rnorm(100000, 6, 2))
cukes <- data.frame(length = rnorm(50000, 7, 2.5))

# Now, combine your two dataframes into one.  
# First make a new column in each that will be 
# a variable to identify where they came from later.
carrots$veg <- 'carrot'
cukes$veg <- 'cuke'

# and combine into your new data frame vegLengths
vegLengths <- rbind(carrots, cukes)
head(vegLengths)

ggplot(vegLengths, aes(length, fill = veg)) + 
   geom_histogram(alpha = 0.5, aes(y = ..density..), position = 'identity')

   
head(df)
df$BioLayer
df[df$BioLayer== "Bio9",]

# ggplot("data.frame con los datos", aes("nombre de la variable que querés graficar", fill= "nombre de la variable que distingue presencias de background"))...
   
ggplot(df[df$BioLayer== "Bio16",c(1,3)], aes(Val, fill = Category)) + 
   geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity', binwidth= 5) + xlab("Bio16") + ylab("Cantidad de registros")

# Fijate que binwidth da cuenta del ancho de las barras
windows()   
ggplot(df[df$BioLayer== "Bio16",c(1,3)], aes(Val, fill = Category)) + 
   geom_histogram(alpha = 0.5, aes(y = ..count..), position = 'identity') + xlab("Bio16") + ylab("Cantidad de registros")
