# source: http://datascienceplus.com/working-with-databases-in-r/

# Download adverse events data

year_start=2013
year_last=2015

for (i in year_start:year_last){
  j=c(1:4)
  for (m in j){
    url1<-paste0("http://www.nber.org/fda/faers/",i,"/demo",i,"q",m,".csv.zip")
    download.file(url1,dest="data.zip") # Demography
    unzip ("data.zip")
    url2<-paste0("http://www.nber.org/fda/faers/",i,"/drug",i,"q",m,".csv.zip")
    download.file(url2,dest="data.zip")   # Drug 
    unzip ("data.zip")
    url3<-paste0("http://www.nber.org/fda/faers/",i,"/reac",i,"q",m,".csv.zip")
    download.file(url3,dest="data.zip") # Reaction
    unzip ("data.zip")
    url4<-paste0("http://www.nber.org/fda/faers/",i,"/outc",i,"q",m,".csv.zip")
    download.file(url4,dest="data.zip") # Outcome
    unzip ("data.zip")
    url5<-paste0("http://www.nber.org/fda/faers/",i,"/indi",i,"q",m,".csv.zip")
    download.file(url5,dest="data.zip") # Indication for use
    unzip ("data.zip")
  }
}

--