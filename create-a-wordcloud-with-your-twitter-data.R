
# source: http://thinktostart.com/create-a-wordcloud-with-your-twitter-data/

library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)

# Twitter Authentication with R:
# las API keys y los token aquí: https://apps.twitter.com/

api_key <- "YAJlNzbrOuePpHLjkND1w"

api_secret <- "KH1yxTut32jD5ADN2g2D1ATioEH5BVOYeMCVvxMEs"

access_token <- "9232912-4URGmvirxQ6CF3WGenAarGpZ1pVq50pNILCo4B6J76"

access_token_secret <- "J4tzVYGrVUoEx6HXcJk7df1rGLtP9VelAnHsOzBUuPovJ"

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# By this step we got our tweets

tweets = searchTwitter("Marbella", n=200)

# We now have to get the Text from our tweets to analyze them. We do this with:

tweets.text = lapply(tweets,function(t)t$getText())

# Sometimes this text has invalid characters in it which 
# will make our API crash; so we have to remove them.
# We can use a function of the site Viralheat to do so:

clean.text <- function(some_txt)
{
  some_txt = gsub("&amp", "", some_txt)
  some_txt = gsub("(RT|via)((?:\b\\W*@\\w+)+)", "", some_txt)
  some_txt = gsub("@\\w+", "", some_txt)
  some_txt = gsub("[[:punct:]]", "", some_txt)
  some_txt = gsub("[[:digit:]]", "", some_txt)
  some_txt = gsub("http\\w+", "", some_txt)
  some_txt = gsub("[ t]{2,}", "", some_txt)
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  
  # define "tolower error handling" function
  
  try.tolower = function(x)
  {
    y = NA
    try_error = tryCatch(tolower(x), error=function(e) e)
    if (!inherits(try_error, "error"))
      y = tolower(x)
    return(y)
  }
  
  some_txt = sapply(some_txt, try.tolower)
  some_txt = some_txt[some_txt != ""]
  names(some_txt) = NULL
  return(some_txt)
  
}

# Clean text:

clean_text = clean.text(tweets.text)

# We add this clean text to a so called Corpus, 
# this is the main structure in the tool tm to save 
# collections of text documents. To fill this Vector 
# we have to use the VectorSource attribute. This looks like this:
  
tweet_corpus = Corpus(VectorSource(clean_text))

# To go on we have to transform this Corpus in a so-called Term-document Matrix. 
# This matrix describes the frequency of terms that occur in a collection of documents.

tdm = TermDocumentMatrix(tweet_corpus, control = 
                           list(removePunctuation = TRUE,stopwords = 
                                  c("machine", 
                                    "learning", 
                                    stopwords("english")), removeNumbers = TRUE, tolower = TRUE))


# Ok now we have our tdm. We have to do now is arrange our words 
# by frequencies and put them in the wordcloud. 
# But before we have to install the wordcloud tool:

install.packages(c("wordcloud","tm"),repos="http://cran.r-project.org")
library(wordcloud)

require(plyr)
m = as.matrix(tdm) #we define tdm as matrix
word_freqs = sort(rowSums(m), decreasing=TRUE) #now we get the word orders in decreasing order
dm = data.frame(word=names(word_freqs), freq=word_freqs) #we create our data set
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2")) #and we visualize our data

# Ok here we have our wordcloud. If you want to save it to your computer you can do it with:

png("Cloud.png", width=12, height=8, units="in", res=300)

wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

dev.off()












