# source: https://rpubs.com/joscani/unemployment_rate_spain

list.of.packages <- c("MicroDatosEs","rgdal", "lme4","RCurl", "dplyr", "sjPlot", "ggplot2", "broom", "classInt", "reshape2")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[, "Package"])]
if (length(new.packages))
  install.packages(new.packages)

# Importar libreria
lapply(list.of.packages,
       require,
       character.only = TRUE,
       quietly = TRUE)

# El INE tiene un FTP accesible (ftp://www.ine.es/)

file_location <- "ftp://www.ine.es/temas/epa/datos_1t18.zip"
td <- tempdir()
tf <- tempfile(tmpdir = td, fileext = ".zip")

# descargar el fichero 
download.file(file_location, tf)

# Nombre del fichero descomprimido
fname <- unzip(tf, list = TRUE)$Name[1]

# Descomprimir el fichero en directorio temporal
unzip(tf,
      files = fname,
      exdir = td,
      overwrite = TRUE)

# fpath is the full path to the extracted file
fpath <- file.path(td, fname)

# Leemos la EPA usando la función epa2005del paquete MicroDatosEs
epa <- epa2005(fpath)
names(epa) <- tolower(names(epa))

# Seleccionamos solo las variables que nos interesan

epa <- subset(epa, select = c(prov, edad, nforma, aoi, factorel))

DT::datatable(epa[1:100,])

# Recode data

recodificacion <- function (dat) {
  dat$aoi[grepl("^Inactivos", dat$aoi)] <- "i"
  dat$aoi[grepl("[O-o]cupados", dat$aoi)] <- "o"
  dat$aoi[grepl("^Parados", dat$aoi)] <- "p"
  
  dat$aoi <- factor(dat$aoi)
  dat$nforma3 <- dat$nforma
  dat$nforma3[dat$nforma == "Analfabetos" |
                dat$nforma == "Educación primaria" |
                dat$nforma == "Educación primaria incompleta"] <-
    "Est primarios o menos"
  dat$nforma3[dat$nforma == "Educación superior"] <-
    "Est. Universitarios"
  dat$nforma3[dat$nforma == "Primera etapa de educación secundaria" |
                dat$nforma == "Segunda etapa de educación secundaria, orientación general" |
                dat$nforma == "Segunda etapa de educación secundaria, orientación profesional"] <-
    "Est. Secundarios"
  
  dat$nforma3 <- factor(dat$nforma3)
  
  dat$gedad <- dat$edad
  dat$gedad[dat$edad == "de 0 A 4 años" |
              dat$edad == "de 5 A 9 años" |
              dat$edad == "de 10 A 15 años"] <- "15 años o menos "
  dat$gedad[dat$edad == "de 16 A 19 años" |
              dat$edad == "de 20 A 24 años" |
              dat$edad == "de 25 A 29 años" |
              dat$edad == "de 30 A 34 años"] <- "De 16 a 34"
  
  dat$gedad[dat$edad == "de 35 A 39 años" |
              dat$edad == "de 40 A 44 años" |
              dat$edad == "de 45 A 49 años" |
              dat$edad == "de 50 A 54 años"] <-  "De 35 a 54"
  
  dat$gedad[dat$edad == "de 55 A 59 años" |
              dat$edad == "de 60 A 64 años" |
              dat$edad == "65 o más años"] <-  "55 o más"
  
  
  dat$gedad <-
    factor(dat$gedad,
           levels = c("15 años o menos ", "De 16 a 34", "De 35 a 54", "55 o más"))
  
  dat
}

epa <- recodificacion(epa)

head(epa)

#Añadimos el código de provincia para poder unir posteriormente con un shapefile.
# En los ficheros internos del paquete MicroDatosEs vienen metadatos útiles que nos sirven para este propósito.

metadatos_epa <-  system.file("metadata", "epa_mdat2.txt", 
                              package = "MicroDatosEs")

epa_mdat2 <- read.table(metadatos_epa, header = T, sep = "\t", 
                        fileEncoding = "UTF-8", stringsAsFactors = FALSE)

head(epa_mdat2)

epa_mdat2 <- epa_mdat2[epa_mdat2$var=="PROV",]


epa <-  epa %>% 
  left_join(epa_mdat2[, c("llave","valor")], by = c("prov" = "valor"))
epa

# Más en https://rpubs.com/joscani/unemployment_rate_spain












