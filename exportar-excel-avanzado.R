library(tidyverse)
library(openxlsx)

# Figure 1
bldStyle  <- createStyle(fontSize = 14, fontColour = "black", textDecoration = c("BOLD"))
wb <- createWorkbook()
addWorksheet(wb, "starwars")
writeData(wb, 1, starwars, colNames=TRUE, headerStyle = bldStyle)
saveWorkbook(wb, "Starwars_default.xlsx", overwrite = TRUE)

# Figure 2
wb <- createWorkbook()
addWorksheet(wb, "starwars")
writeData(wb, 1, starwars, colNames=TRUE, headerStyle = bldStyle)
setColWidths(wb, sheet = 1, cols = 1:ncol(starwars), widths = "auto")
saveWorkbook(wb, "Starwars_autowide.xlsx", overwrite = TRUE)

# Figure 3
wb <- createWorkbook()
addWorksheet(wb, "storms")
writeData(wb, 1, storms, colNames=TRUE, headerStyle = bldStyle)
setColWidths(wb, sheet = 1, cols = 1:ncol(storms), widths = "auto")
saveWorkbook(wb, "storms_autowide.xlsx", overwrite = TRUE)

# Figure 4
wb <- createWorkbook()
addWorksheet(wb, "starwars")
hs1 <- createStyle(fgFill = "#f9f9f9", halign = "CENTER", textDecoration = "italic",
                   border = "TopBottomLeftRight", fontSize = 13)
row1 <- t(c("", "UseforBMI", "", "colors", "", "", rep("", 8)))
addStyle(wb, sheet = 1, hs1, rows = 1, cols = 1:ncol(row1))
writeData(wb, 1, x = row1, colNames=FALSE, headerStyle = bldStyle)
writeData(wb, 1, x = starwars, startRow = 2, colNames=TRUE, headerStyle = bldStyle)
mergeCells(wb, 1, cols = 2:3, rows = 1)
mergeCells(wb, 1, cols = 4:6, rows = 1)
setColWidths(wb, sheet = 1, cols = 1:ncol(starwars), widths = "auto")
saveWorkbook(wb, "starwars_autowide_mergedcols.xlsx", overwrite = TRUE)

# Figure 5
width_adjuster <- 1.5
wb <- createWorkbook()
addWorksheet(wb, "starwars")
hs1 <- createStyle(fgFill = "#f9f9f9", halign = "CENTER", textDecoration = "italic",
                   border = "TopBottomLeftRight", fontSize = 13)
row1 <- t(c("", "UseforBMI", "", "colors", "", "", rep("", 8)))
addStyle(wb, sheet = 1, hs1, rows = 1, cols = 1:ncol(row1))
writeData(wb, 1, x = row1, colNames=FALSE, headerStyle = bldStyle)
writeData(wb, 1, x = starwars, startRow = 2, colNames=TRUE, headerStyle = bldStyle)
mergeCells(wb, 1, cols = 2:3, rows = 1)
mergeCells(wb, 1, cols = 4:6, rows = 1)
# column widths based on values in the dataframe
width_vec <- apply(starwars, 2, function(x) max(nchar(as.character(x)) + width_adjuster, na.rm = TRUE))
# column widths based on the column header widths
width_vec_header <- nchar(colnames(starwars))  + width_adjuster
# now use parallel max (like vectorized max) to capture the lengthiest value per column
width_vec_max <- pmax(width_vec, width_vec_header)
setColWidths(wb, sheet = 1, cols = 1:ncol(row1), widths = width_vec_max)
saveWorkbook(wb, "starwars_manualwide_mergedcols.xlsx", overwrite = TRUE)