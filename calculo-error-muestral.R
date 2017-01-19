
# source: http://cafecondatos.es/2016/06/por-si-un-dia-te-preguntan-que-es-el-muestreo/

# Cálculo del error muestral

emuestral <- function(n=400, 
                      p=0.5, 
                      conf=0.9545,
                      pbl=100000){
  e<-NULL
  if (pbl>=100000){
    e2<-(qnorm(conf+(1-conf)/2)^2)*p*(1-p)/n
    e<-sqrt(e2)
  }else{
    e2<-(((qnorm(conf+(1-conf)/2)^2)*p*(1-p)*(pbl-n))/n)/(pbl-1)
    e<-sqrt(e2)
  }
  return(e)
  
}

emuestral(n=400, conf=0.9545, pbl=1000000)
