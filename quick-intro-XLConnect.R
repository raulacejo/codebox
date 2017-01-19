
# source : http://altons.github.io/r/2015/02/13/quick-intro-to-xlconnect/

library(XLConnect)


# Load and Excel workbook (create if not existing)

wb <- loadWorkbook("C:/Users/rauace/Documents/xlconnect1.xlsx",create=T)

# Creating Sheets

createSheet(wb,"cars stats")
createSheet(wb,"Iris")
createSheet(wb,"Rivers")
createSheet(wb,"Quakes location Fiji")


# Writing data to WorkSheets

writeWorksheet(wb,cars,"cars stats")
writeWorksheet(wb,iris,"Iris")
writeWorksheet(wb,rivers,"Rivers")
writeWorksheet(wb,quakes,"Quakes location Fiji")

# Saving Workbooks

saveWorkbook(wb) # Alternatively you can pass a filename like saveWorkbook(wb,'path_to_file')

# Basic Example

wb1 <- loadWorkbook("C:/Users/rauace/Documents/example1.xlsx", create = TRUE)
createSheet(wb1, name = "chickSheet")
writeWorksheet(wb1, ChickWeight, sheet = "chickSheet", startRow = 3, startCol = 4)
saveWorkbook(wb1)

# Read Data from Worksheet

wb2 <- loadWorkbook("C:/Users/rauace/Documents/example1.xlsx", create = F)
chick <- readWorksheet (wb2,"chickSheet", 3, 4, 581, 7, header = TRUE)
summary(chick)

# Read Data straight from File

iris <- readWorksheetFromFile("C:/Users/rauace/Documents/xlconnect1.xlsx",sheet="iris", header=T)
summary(iris)

# Write Data straight to File

writeWorksheetToFile("C:/Users/rauace/Documents/example2.xlsx",data=iris,sheet="iris2")
writeWorksheetToFile("C:/Users/rauace/Documents/example2.xlsx",data=iris,sheet="iris3")

# Named Regions

## Let's create some dummy data

### Invoice ID
inv_id <- data.frame(id=527)
### Invoice date
inv_date <- data.frame(id='17/11/2014')
### Bill Contact
inv_contact <- data.frame(id='Chuck Norris')
### Company name
inv_company <- data.frame(id='RoundHouse Kick')
### Items
items <- data.frame(description=c("Nunchakus","Karate GI","Black Belt"),unit=c(3,5,1),price=c(3.95,45,7))

### Load xls template in memory
invoice_wb <- loadWorkbook("C:/Users/rauace/Documents/invoice_template.xlsx", create = TRUE)
###Using XLConnect you normally overwrite the cell styles unless you set the style action to be "none" using
setStyleAction(invoice_wb,XLC$"STYLE_ACTION.NONE")

### Insert inv_id in the template
writeNamedRegion(invoice_wb, inv_id, name = "rngInvoice", header=F)
### Insert inv_date in the template
writeNamedRegion(invoice_wb, inv_date, name = "invoice_date", header=F)
### Insert Bill contact in the template
writeNamedRegion(invoice_wb, inv_contact, name = "bill_contact", header=F)
### Insert Company name in the template
writeNamedRegion(invoice_wb, inv_company, name = "bill_company", header=F)

##Let create some named regions manually
### Items
createName(invoice_wb, name = "items", formula = "invoice!$A$16", overwrite = TRUE)
writeNamedRegion(invoice_wb, items, name = "items", header=F)

### Since we have a lot of calculation inside the invoice template we need to force the 
### calculation after data has been inserted/updated
setForceFormulaRecalculation(invoice_wb, sheet = 1, TRUE)
###Save our template to a different file
saveWorkbook(invoice_wb, "C:/Users/rauace/Documents/invoice_20141117.xlsx")





















