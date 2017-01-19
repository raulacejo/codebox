# source: http://www.lunametrics.com/blog/2016/06/02/getting-started-r-google-analytics/


# First, you need to import your Google Analytics data into R. 
# In this post, I’ll be using the rga package to download the data 
#directly into R from the Google Analytics API


library(rga)
library(curl)

rga.open(instance = "ga")

id <- "34091891"

gadata <- ga$getData(id, start.date = as.Date("2016-01-01"),
                     end.date = as.Date("2016-01-31"), 
                     metrics = "ga:uniquepageviews",
                     dimensions = "ga:pagePath",
                     # filters="ga:pagePath=~/blog/",
                     batch=TRUE)
# Here are a few other quick commands that will show you a snapshot of the data you downloaded

head(gadata)
str(gadata)
unique(gadata$pagePath)
summary(gadata$uniquepageviews)
sd(gadata$uniquepageviews)
library(ggplot2)
ggplot(gadata, aes(uniquepageviews)) + geom_histogram() + theme_bw() + ggtitle("Unique Pageviews to Blog Posts")

# Other dimension:

gadata <- ga$getData(id, start.date = as.Date("2016-01-01"),
                     end.date = as.Date("2016-01-31"), 
                     metrics = "ga:uniquepageviews",
                     dimensions = "ga:date",
                     # filters="ga:pagePath=~/blog/",
                     batch=TRUE)
# Here are a few other quick commands that will show you a snapshot of the data you downloaded

head(gadata)
str(gadata)
unique(gadata$pagePath)
summary(gadata$uniquepageviews)
sd(gadata$uniquepageviews)
library(ggplot2)
ggplot(gadata, aes(uniquepageviews)) + geom_histogram() + theme_bw() + ggtitle("By date")
