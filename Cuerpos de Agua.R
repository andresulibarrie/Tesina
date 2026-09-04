#cuepors de agua
Agua<-readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/areas_de_aguas_continentales_perenne", "areas_de_aguas_continentales_perenne")
plot(Agua)
proj4string(Agua)

AGmap<- readOGR("C:/Users/Usuario/Documents/1AGUARATESINA/Capas/poligonoaguara","Chrysocyon_brachyurus")
plot(AGmap)
proj4string(AGmap)

Agua_sptr <- spTransform(Agua, CRS("+proj=longlat +ellps=WGS84 +towgs84=0,0,0,0,0,0,0 +no_defs"))
proj4string(Agua_sptr)

Agua_crop <- crop(Agua_sptr, AGmap)
plot(Agua_crop)
Agua_crop_mask <- mask(Agua_crop, AGmap)
plot(Agua_crop_mask )
