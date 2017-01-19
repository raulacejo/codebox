#source: http://analisisydecision.es/el-paquete-de-r-weatherdata-para-la-obtencion-de-datos-meteorologicos-en-espana/

install.packages("weatherData")
library(weatherData)

albacete = getWeatherForYear("LEAB",2015)
malaga <- getWeatherForYear("AGP",2016)
malaga

