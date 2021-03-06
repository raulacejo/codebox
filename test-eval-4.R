# Instrucci�n para instalar el paquete. Esto solo lo ten�is que hacer la primera vez.
install.packages('rpart')
install.packages('rpart.plot')

# Una vez instalado y siempre que quer�is repetir la pr�ctica, deber�is cargar primero las bibliotecas rpart y rpart.plot.
library(rpart)
library(rpart.plot)
#Base de datos de ejemplo, con 30 atributos num�ricos sobre pacientes de c�ncer
# Opci�n de recuperar datos de Internet
dataRaw <- read.table("http://archive.ics.uci.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data", sep=",");

#Visualizar un resumen de los datos
summary(dataRaw)
head(dataRaw)

N=dim(dataRaw)[1];
all=seq(1, N);
test=seq(1, N, 3);
train=setdiff(all, test);

xtrain=dataRaw[train,];
xtest=dataRaw[test,];

sum(xtrain[,2] == 'N') * 100 / nrow(xtrain)
sum(xtest[,2] == 'N') * 100 / nrow(xtest)

table(xtrain$V2)
table(xtest$V2)

# Generamos el �rbol de decisi�n t1 seleccionando V2 como variable objetivo
fvars <- paste("V2 ~", paste(paste("V",3:32,sep=""),collapse="+"));
t1 <- rpart(fvars, data=xtrain, method="class");

# Aplicamos el �rbol de decisi�n t1 sobre el juego de datos xtrain
y1train <- predict(t1,xtrain, type="class")
# Generamos una matriz de confusi�n
tab.train <- table(xtrain$V2,y1train)
tab.train
# Calculamos el porcentaje de aciertos
(tab.train[1,1]+tab.train[2,2]) * 100 / sum(tab.train)
