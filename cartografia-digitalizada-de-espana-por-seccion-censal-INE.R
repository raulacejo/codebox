
# source: http://analisisydecision.es/cartografia-digitalizada-de-espana-por-seccion-censal/

#mapas con secciones censales

library(maptools)
ub_shp = "C:/Users/rauace/Documents/cartografia_censo2011_nacional/SECC_CPV_E_20111101_01_R_INE.shp"
seccion_censal = readShapeSpatial(ub_shp)
barcelona = seccion_censal[seccion_censal$NMUN=="Barcelona",]
plot(barcelona)

