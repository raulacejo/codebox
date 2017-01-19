# source : http://www.milanor.net/blog/steps-connect-r-excel-xlconnect/

# Required packages

library(XLConnect)
library(reshape)
library(ggplot2)


# Create a new empty xlsx file trough R

outDir <- "C:/Users/rauace/Documents"
fileXls <- paste(outDir, "newFile.xlsx", sep = "/")
exc <- loadWorkbook(fileXls, create = TRUE)
createSheet(exc,'Input')
saveWorkbook(exc)

# Populate an empty xlsx sheet with R

input <- data.frame('inputType'=c('Day','Month'),'inputValue'=c(2,5))
writeWorksheet(exc, input, sheet = "input", startRow = 1, startCol = 2)
saveWorkbook(exc)

# Add other sheets to the workbook
# Command createName create a named region ‘Airquality’ starting from the cell $A$1 of sheet Airquality. 
# Command writeNamedRegion writes airquality data.frame with headers in the named region ‘Airquality’.

require(reshape)
createSheet(exc,'Airquality')
airquality$isCurrent<-NA
createName(exc, name='Airquality',formula='Airquality!$A$1')
writeNamedRegion(exc, airquality, name = 'Airquality', header = TRUE)
saveWorkbook(exc)


# Add an Excel formula to an xlsx sheet trough R

colIndex <- which(names(airquality) == 'isCurrent')
letterDay <- idx2col(which(names(airquality) == 'Day'))
letterMonth <- idx2col(which(names(airquality) == 'Month'))
formulaXls <- paste('IF(AND(',
                    letterMonth,
                    2:(nrow(airquality)+1),
                    '=Input!C3,',
                    letterDay,
                    2:(nrow(airquality)+1),
                    '=Input!C2)',
                    ',1,0)',sep='')
setCellFormula(exc, sheet='Airquality',2:(nrow(airquality)+1),colIndex,formulaXls)
saveWorkbook(exc)

# Read and modify with R an existing xlsx file

exc2 <- loadWorkbook(fileXls, create = FALSE)
dtAir <- readWorksheet(exc2,'Airquality')
createSheet(exc2, name = "OzonePlot")
createName(exc2, name='OzonePlot',formula='OzonePlot!$A$1')
saveWorkbook(exc2)

# Adding an R plot (as image) to Excel

library(ggplot2)
fileGraph <- paste(outDir,'graph.png',sep='/')
png(filename = fileGraph, width = 800, height = 600)
ozone.plot <- ggplot(dtAir, aes(x=Day, y=Ozone)) + 
  geom_point() + 
  geom_smooth()+
  facet_wrap(~Month, nrow=1)
print(ozone.plot)
invisible(dev.off())
addImage(exc2,fileGraph, 'OzonePlot',TRUE)
saveWorkbook(exc2)


