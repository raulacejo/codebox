
# source: http://thinktostart.com/analysis-of-twitter-devices-with-r/

library(twitteR)

# Twitter Authentication with R:
# las API keys y los token aquí: https://apps.twitter.com/

api_key <- "YAJlNzbrOuePpHLjkND1w"
api_secret <- "KH1yxTut32jD5ADN2g2D1ATioEH5BVOYeMCVvxMEs"
access_token <- "9232912-4URGmvirxQ6CF3WGenAarGpZ1pVq50pNILCo4B6J76"
access_token_secret <- "J4tzVYGrVUoEx6HXcJk7df1rGLtP9VelAnHsOzBUuPovJ"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# Getting the data

tweets = searchTwitter("Social Media", n=20)

# Analyze Twitter Devices with R

devices <- sapply(tweets, function(x) x$getStatusSource())
devices <- gsub("","", devices)
devices <- strsplit(devices, ">")
devices <- sapply(devices,function(x) ifelse(length(x) > 1, x[2], x[1]))

# Ok now we have our devices can put them in a nice looking pie chart like this one.

pie(table(devices))
