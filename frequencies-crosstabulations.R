# source: http://www.statmethods.net/stats/frequencies.html

# Antes de hacer las tablas, cargamos y preparadmos los datos de golf.

library(data.table)
library(dplyr)
library(xlsx)

golf <- read.csv("Z:/SAETA/Segmentos/Sistema Actualizacion Anual/2015/Golf/golf15.csv", 
                 header = TRUE, sep = ";",dec = ",")

attach(golf)

golf$CONTADOR <- as.numeric(CONTADOR)
golf$Segmento <- as.numeric(Segmento)
golf$ID <- as.character(ID)
golf$CodPto <- as.character(CodPto)         
golf$DescPto <- as.character(DescPto)     
golf$Encuestador <- as.numeric(Encuestador)   
golf$FECHA <- as.Date(FECHA, format = "%d/%m/%Y")        
golf$HORAENTREVISTA <- as.character(HORAENTREVISTA)
golf$Enc_Conteo  <- factor(Enc_Conteo, levels = c(1,2), 
                           labels = c("Registro de Encuesta", "Registro de Conteo"))
golf$TVisitante <- factor(TVisitante, levels = c(1,2,3), 
                          labels = c("Residente", "Excursionista", "Turista"))
golf$Resp01 <- factor(Resp01, levels = c(1,2), labels =c("Si", "No"))
golf$Resp01_A <- factor(Resp01_A, levels = c(1,2), labels =c("Si", "No"))
golf$Resp02_1 <- factor(Resp02_1, levels = c(1,2,3,4,5,6,7,8,9,10,11), 
                        labels =c("Sol y playa", "Cultural", "Naturaleza",
                                  "Amigos y familiares","Golf", "Camping", 
                                  "Salud y belleza", "Negocios y reuniones", 
                                  "Nautico", "Cruceros", "Otros"))
golf$Resp02_2   <- factor(Resp02_2, levels = c(1,2,3,4,5,6,7,8,9,10,11), 
                          labels =c("Sol y playa", "Cultural", "Naturaleza", 
                                    "Amigos y familiares", "Golf", "Camping", 
                                    "Salud y belleza", "Negocios y reuniones", 
                                    "Nautico", "Cruceros", "Otros"))
golf$Resp02_Otro <- as.character(Resp02_Otro)  
golf$Resp03   <- factor(Resp03, levels = c(1,2,3,4,5,6,7,8,9,10,11,12,13), 
                        labels =c("Andalucía", "Resto de España", "Alemania", 
                                  "Francia", "Holanda", "Suecia", "Dinamarca", 
                                  "Finlandia", "Noruega", "Reino Unido", "Irlanda", 
                                  "Resto UE", "Otros"))
golf$Resp03_Otros <- as.character(Resp03_Otros)  
golf$MunResi  <- as.character(MunResi)   
golf$UZonResi <- as.character(UZonResi) 
golf$MunAnoche  <- as.character(MunAnoche)  
golf$UZonPern <- as.character(UZonPern) 
golf$Resp04 <- as.numeric(Resp04)  
golf$Resp05 <- as.numeric(Resp05)    
golf$Resp05_Moneda <- as.character(Resp05_Moneda)
golf$Resp05_Personas <- as.numeric(Resp05_Personas)
golf$Resp05_CANT1 <- as.numeric(Resp05_CANT1)
golf$Resp05_CANT2 <- as.numeric(Resp05_CANT2)
golf$Resp05_CANT3 <- as.numeric(Resp05_CANT3)
golf$Resp05_CANT4 <- as.numeric(Resp05_CANT4)
golf$Resp05_CANT5 <- as.numeric(Resp05_CANT5)
golf$Resp05_CANT6 <- as.numeric(Resp05_CANT6)
golf$Resp05_CANT7 <- as.numeric(Resp05_CANT7)
golf$Resp05_Otro <- as.character(Resp05_Otro)
golf$Resp06 <- as.numeric(Resp06)
golf$Resp06_Moneda <- as.character(Resp06_Moneda)
golf$Resp06_Personas <- as.numeric(Resp06_Personas)
golf$Resp06_CANT1 <- as.numeric(Resp06_CANT1)
golf$Resp06_CANT2 <- as.numeric(Resp06_CANT2)
golf$Resp06_CANT3 <- as.numeric(Resp06_CANT3)
golf$Resp06_CANT4 <- as.numeric(Resp06_CANT4)
golf$Resp06_CANT5 <- as.numeric(Resp06_CANT5)  
golf$Resp07 <- as.numeric(Resp07)    
golf$Resp08_A1 <- as.numeric(Resp08_A1)     
golf$Resp08_A2 <- as.numeric(Resp08_A2)  
golf$Resp08_B <- factor(Resp08_B, levels = c(1,2), labels =c("Si", "No"))  
golf$P09_OpNo <- factor(P09_OpNo, levels = c(1,2), labels =c("Si", "No"))
golf$P09_Op2 <- factor(P09_Op2, levels = c(1,2), labels =c("Si", "No"))
golf$P09_Op3 <- factor(P09_Op3, levels = c(1,2), labels =c("Si", "No"))
golf$P09_Op4 <- factor(P09_Op4, levels = c(1,2), labels =c("Si", "No"))
golf$P09_Op5 <- factor(P09_Op5, levels = c(1,2), labels =c("Si", "No"))
golf$P09_Op6 <- factor(P09_Op6, levels = c(1,2), labels =c("Si", "No"))
golf$P09_OpOtros <- factor(P09_OpOtros, levels = c(1,2), labels =c("Si", "No"))
golf$P09_Otros <- as.character(P09_Otros)
golf$Resp10 <- factor(Resp10, levels = c(1,2), labels =c("Hombre", "Mujer"))

detach(golf)

setnames(golf, old = c('CONTADOR','Segmento','ID','CodPto','DescPto','Encuestador',
                       'FECHA','HORAENTREVISTA','Enc_Conteo','TVisitante','Resp01',
                       'Resp01_A','Resp02_1','Resp02_2','Resp02_Otro','Resp03',
                       'Resp03_Otros','MunResi','UZonResi','MunAnoche','UZonPern',
                       'Resp04','Resp05','Resp05_Moneda','Resp05_Personas',
                       'Resp05_CANT1','Resp05_CANT2','Resp05_CANT3','Resp05_CANT4',
                       'Resp05_CANT5','Resp05_CANT6','Resp05_CANT7','Resp05_Otro',
                       'Resp06','Resp06_Moneda','Resp06_Personas','Resp06_CANT1',
                       'Resp06_CANT2','Resp06_CANT3','Resp06_CANT4','Resp06_CANT5',
                       'Resp07','Resp08_A1','Resp08_A2','Resp08_B','P09_OpNo',
                       'P09_Op2','P09_Op3','P09_Op4','P09_Op5',
                       'P09_Op6','P09_OpOtros','P09_Otros','Resp10'), 
         new = c('contador','segmento','id','codpunto','descpunto','encuestador',
                 'fecha','hora','encuestado','tipovisitante','pernocto','primerdia',
                 'motivo1','motivo2','otromotivo','residencia','residencia_otros',
                 'municipio_res','zona_res','municipiopern','zonapern','pernoctaciones',
                 'coste','coste_moneda','coste_personas','coste_transporte',
                 'coste_alojamiento','coste_restauracion','coste_compras',
                 'coste_greenfees','coste_paquete','coste_otros','coste_otro_es',
                 'gastoayer','gastoayer_moneda','gastoayer_personas',
                 'gastoayer_transporte','gastoayer_alojamiento','gastoayer_restauracion',
                 'gastoayer_compras','gastoayer_greenfees','valoración','camposvisitados'
                 ,'salidascampo','socio','usointernet','usointernet_transporte',
                 'usointernet_alojamiento','usointernet_greenfees','usointernet_info',
                 'usointernet_redes','usointernet_otros','usointernet_otros_es','sexo'))


golf$mes <- month(golf$fecha)
golf$mes <- factor(golf$mes, levels = c(4, 5, 9, 10), labels = c("Abr", "May", "Sep", "Oct"))


-----------------------------------------------------------------------------------------------------


# 2-Way Frequency Table 
attach(golf)
mytable <- table(encuestado, mes) # A will be rows, B will be columns 
mytable # print table 

margin.table(mytable, 1) # A frequencies (summed over B) 
margin.table(mytable, 2) # B frequencies (summed over A)

prop.table(mytable) # cell percentages
prop.table(mytable, 1) # row percentages 
prop.table(mytable, 2) # column percentages

# 3-Way Frequency Table 
mytable <- table(encuestado, mes, descpunto) 
ftable(mytable)


# 3-Way Frequency Table
mytable <- xtabs(~encuestado+mes+descpunto, data=golf)
ftable(mytable) # print table 
summary(mytable) # chi-square test of indepedence


# 2-Way Cross Tabulation
library(gmodels)
ct <- CrossTable(golf$encuestado, golf$mes)

save.xlsx("golf.xlsx", ct)
