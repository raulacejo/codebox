# source: https://pedroconcejero.wordpress.com/2016/03/23/mosaicplots-para-saber-como-son-los-erreros-de-r-hispano/

# Cargamos los datos

setwd("Z:/Personales/Raul/R/data")
erreros <- read.table("R_logo_surveymonkey_data.txt", 
                      sep = "\t",
                      header = T)

dim(erreros)
summary(erreros)

# Cambiamos nombres que nos interesan ahora y solucionamos un pequeño 
# problema con un dato vacío en la pregunta de género. También quiero 
# editar un poco las etiquetas de rol para que no sean tan largas.

colnames(erreros)[1] <- "numencuesta"
colnames(erreros)[2] <- "rol"
colnames(erreros)[3] <- "genero"
colnames(erreros)[4] <- "gredad"

erreros$genero[erreros$genero == ""] <- "No te lo digo"
erreros$genero <- droplevels(erreros$genero)

erreros$rol <- as.character(erreros$rol)
erreros$rol[erreros$rol == "Ninguno de los anteriores"] <- "Ninguno"
erreros$rol[erreros$rol == "Todos los anteriores"] <- "Todos"
erreros$rol <- as.factor(erreros$rol)

summary(erreros)

# Vamos a usar gráficos de mosaico para representar triple cruce: rol - género - edad

library(vcd)

mosaic(~ rol + gredad + genero,
       data = erreros,
       shade = T)

# La gracieta de incluir una respuesta “No te lo digo” y que dos personas lo contesten
# (bueno, en realidad una explícita y otra implícita) hace que el gráfico incluya esas
# líneas que en realidad son ¡nada!. Nos los “cargamos” (los datos) y a ver qué tenemos. 
# Aprovecho y también cambio las etiquetas de género para que se lean mejor.

erreros2 <- erreros[(erreros$genero != "No te lo digo" &
                       erreros$gredad != "Más de 50") , ]

erreros2$genero <- droplevels(erreros2$genero)

erreros2$gredad <- droplevels(erreros2$gredad)

levels(erreros2$genero) <- c("H", "M")

mosaic(~ rol + gredad + genero,
       data = erreros2,
       shade = T)



