# source: http://thinktostart.com/twitter-authentification-with-r/

install.packages(c("devtools", "rjson", "bit64", "httr"))

#RESTART R session!

library(devtools)
install_github("twitteR", username="geoffjentry")
library(twitteR)

# Twitter Authentication with R:
# las API keys y los token aquí: https://apps.twitter.com/

api_key <- "YAJlNzbrOuePpHLjkND1w"

api_secret <- "KH1yxTut32jD5ADN2g2D1ATioEH5BVOYeMCVvxMEs"

access_token <- "9232912-4URGmvirxQ6CF3WGenAarGpZ1pVq50pNILCo4B6J76"

access_token_secret <- "J4tzVYGrVUoEx6HXcJk7df1rGLtP9VelAnHsOzBUuPovJ"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# If you want to test your authentication just try to get some tweets with:

searchTwitter("iphone")
