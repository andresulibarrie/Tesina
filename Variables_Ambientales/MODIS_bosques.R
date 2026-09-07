#al haber cargado ya todos los mapas de modis en el archivo usodesuelo-cultivo solo hago recategorizacion

Bosque <- Modis_1812_proj
Bosque [Bosque > 7] <- NA
Bosque [Bosque < 7] <- 7
plot(Bosque)
writeRaster(x= Bosque, filename= "Bosque_1812_raw", format= "GTiff", bylayer= TRUE, suffix=names(Bosque))

Bosque <- Modis_1811_proj
Bosque [Bosque > 7] <- NA
Bosque [Bosque < 7] <- 7
plot(Bosque)
writeRaster(x= Bosque, filename= "Bosque_1811_raw", format= "GTiff", bylayer= TRUE, suffix=names(Bosque))

Bosque <- Modis_0112_proj
Bosque [Bosque > 7] <- NA
Bosque [Bosque < 7] <- 7
plot(Bosque)
writeRaster(x= Bosque, filename= "Bosque_0112_raw", format= "GTiff", bylayer= TRUE, suffix=names(Bosque))

Bosque <- Modis_0111_proj
Bosque [Bosque > 7] <- NA
Bosque [Bosque < 7] <- 7
plot(Bosque)
writeRaster(x= Bosque, filename= "Bosque_0111_raw", format= "GTiff", bylayer= TRUE, suffix=names(Bosque))

#uso de suelo para sabanas (9)
Sabanas  <- Modis_1812_proj
Sabanas [Sabanas < 8] <- NA
Sabanas [Sabanas > 9] <- NA
Sabanas [Sabanas == 8] <- NA
plot(Sabanas)
writeRaster(x= Sabanas, filename= "Sabanas_1812_raw", format= "GTiff", bylayer= TRUE, suffix=names(Sabanas))

Sabanas  <- Modis_1811_proj
Sabanas [Sabanas < 8] <- NA
Sabanas [Sabanas > 9] <- NA
Sabanas[Sabanas == 8] <- NA
plot(Sabanas)
writeRaster(x= Sabanas, filename= "Sabanas_1811_raw", format= "GTiff", bylayer= TRUE, suffix=names(Sabanas))

Sabanas  <- Modis_0112_proj
Sabanas [Sabanas < 8] <- NA
Sabanas [Sabanas > 9] <- NA
Sabanas [Sabanas == 8] <- NA
plot(Sabanas)
writeRaster(x= Sabanas, filename= "Sabanas_0112_raw", format= "GTiff", bylayer= TRUE, suffix=names(Sabanas))

Sabanas  <- Modis_0111_proj
Sabanas [Sabanas < 8] <- NA
Sabanas [Sabanas > 9] <- NA
Sabanas [Sabanas == 8] <- NA
plot(Sabanas)
writeRaster(x= Sabanas, filename= "Sabanas_0111_raw", format= "GTiff", bylayer= TRUE, suffix=names(Sabanas))

#sabanas arboladas

Sabanas  <- Modis_1812_proj
Sabanas [Sabanas < 8] <- NA
Sabanas [Sabanas > 9] <- NA
Sabanas [Sabanas == 9] <- NA
plot(Sabanas)
writeRaster(x= Sabanas, filename= "SabanasB_1812_raw", format= "GTiff", bylayer= TRUE, suffix=names(Sabanas))

Sabanas  <- Modis_1811_proj
Sabanas [Sabanas < 8] <- NA
Sabanas [Sabanas > 9] <- NA
Sabanas[Sabanas == 9] <- NA
plot(Sabanas)
writeRaster(x= Sabanas, filename= "SabanasB_1811_raw", format= "GTiff", bylayer= TRUE, suffix=names(Sabanas))

Sabanas  <- Modis_0112_proj
Sabanas [Sabanas < 8] <- NA
Sabanas [Sabanas > 9] <- NA
Sabanas [Sabanas == 9] <- NA
plot(Sabanas)
writeRaster(x= Sabanas, filename= "SabanasB_0112_raw", format= "GTiff", bylayer= TRUE, suffix=names(Sabanas))

Sabanas  <- Modis_0111_proj
Sabanas [Sabanas < 8] <- NA
Sabanas [Sabanas > 9] <- NA
Sabanas [Sabanas == 9] <- NA
plot(Sabanas)
writeRaster(x= Sabanas, filename= "SabanasB_0111_raw", format= "GTiff", bylayer= TRUE, suffix=names(Sabanas))

#cuerpos de agua
WaterB <- Modis_1811_proj_crop_mask
WaterB [WaterB <17] <- NA
WaterB [WaterB >17] <- NA
plot(WaterB)
writeRaster(x= WaterB, filename= "WaterB_1811", format= "GTiff", bylayer= TRUE, suffix=names(WaterB))

WaterB <- Modis_1812_proj_crop_mask
WaterB [WaterB <17] <- NA
WaterB [WaterB >17] <- NA
plot(WaterB)
writeRaster(x= WaterB, filename= "WaterB_1812", format= "GTiff", bylayer= TRUE, suffix=names(WaterB))
