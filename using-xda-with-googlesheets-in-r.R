# source: https://qualityandinnovation.com/2016/06/19/using-xda-with-googlesheets-in-r/

library(xda)
library(googlesheets)

my.gs <- gs_key("1coJjHXcf5IRjBi0qusw6IK4r0Xt37DRhlmV4Zvv8v8M") 
my.data <- gs_read(my.gs) # Retrieves data from googlesheets and places it into an R object. 
my.df <- as.data.frame(my.data)  # Important! xda needs you to extract only the data in a data frame.

numSummary(my.df)
charSummary(my.df)
bivariate(my.df,'date','F')
