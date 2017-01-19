
# source: http://thinktostart.com/create-twitter-sentiment-word-cloud-in-r/

# We need some packages for this tutorial but they are all available at CRAN:

library(twitteR)
library(RCurl)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)

# The last preparation step is defining two functions which will help us a lot. 
# The first cleans the text we send it and removes unwanted chars and the second 
# sends the text to the datumbox API.

clean.text <- function(some_txt)
{
  some_txt <- gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
  some_txt = gsub("@\\w+", "", some_txt)
  some_txt = gsub("[[:punct:]]", "", some_txt)
  some_txt = gsub("[[:digit:]]", "", some_txt)
  some_txt = gsub("http\\w+", "", some_txt)
  some_txt = gsub("[ t]{2,}", "", some_txt)
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  some_txt = gsub("amp", "", some_txt)
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

getSentiment <- function (text, key){
  
  text <- URLencode(text);
  
  #save all the spaces, then get rid of the weird characters that break the API, 
  # then convert back the URL-encoded spaces.
  
  text <- str_replace_all(text, "%20", " ");
  text <- str_replace_all(text, "%\\d\\d", "");
  text <- str_replace_all(text, " ", "%20");
  
  if (str_length(text) > 360){
    text <- substr(text, 0, 359);
  }
  ##########################################
  
  data <- getURL(paste("http://api.datumbox.com/1.0/TwitterSentimentAnalysis.json?api_key=", key, "&text=",text, sep=""))
  
  js <- fromJSON(data, asText=TRUE);
  
  # get mood probability
  sentiment = js$output$result
  
  ###################################
  return(list(sentiment=sentiment))
}

# Let´s start!
# First we have to get some tweets:

tweets = searchTwitter("Andalucia", 30, lang="en")

# Then we get the text from these tweets and remove all the unwanted chars:

# get text
tweet_txt = sapply(tweets, function(x) x$getText())

# clean text
tweet_clean = clean.text(tweet_txt)
tweet_num = length(tweet_clean)

# Now we create a dataframe where we can save all our data in like the tweet 
# text and the results of the sentiment analysis.

tweet_df = data.frame(text=tweet_clean, sentiment=rep("", tweet_num),stringsAsFactors=FALSE)

# In the next step we apply the sentiment analysis function getSentiment() 
# to every tweet text and save the result in our dataframe. 
# Then we delete all the rows which don´t have a sentiment score. 
# This sometimes happens when unwanted characters survive our cleaning procedure.

# apply function getSentiment

db_key = "1c48e42dff8540ed0d193d3ef80a9f54" # datumbox API (http://www.datumbox.com/apikeys/view/)

sentiment = rep(0, tweet_num)
for (i in 1:tweet_num)
{
  tmp = getSentiment(tweet_clean[i], db_key)
  
  tweet_df$sentiment[i] = tmp$sentiment
  
  print(paste(i," of ", tweet_num))
  
}

# delete rows with no sentiment
tweet_df <- tweet_df[tweet_df$sentiment!="",]

# Now that we have our data we can start building the wordcloud.

# First we get the different forms of sentiment scores the API returned. 
# If you used the Datumbox API you will have positive, neutral and negative. 
# With the help of them we divide the tweet texts into categories.

#separate text by sentiment
sents = levels(factor(tweet_df$sentiment))

# The next line of code seems to be a little bit complicated. 
# But it is enough if you know that it generates labels for each 
# sentiment category which include the percents.

# get the labels and percents

labels <- lapply(sents, function(x) paste(x,format(
                round((length((tweet_df[tweet_df$sentiment ==x,])$text)
                       /length(tweet_df$sentiment)*100),2),nsmall=2),"%"))



# Then we create the so called docs for each category and add the tweet texts to these categories:

nemo = length(sents)
emo.docs = rep("", nemo)
for (i in 1:nemo)
{
  tmp = tweet_df[tweet_df$sentiment == sents[i],]$text
  
  emo.docs[i] = paste(tmp,collapse=" ")
}

# The next steps are the same steps you would use for a “normal” worcloud. 
# We just create a TermDocument Matrix and call the function comparison.cloud() 
# from the “wordcloud” package

# remove stopwords
emo.docs = removeWords(emo.docs, stopwords("german"))
emo.docs = removeWords(emo.docs, stopwords("english"))
corpus = Corpus(VectorSource(emo.docs))
tdm = TermDocumentMatrix(corpus)
tdm = as.matrix(tdm)
colnames(tdm) = labels

# comparison word cloud
comparison.cloud(tdm, colors = brewer.pal(nemo, "Dark2"),
                 scale = c(3,.5), random.order = FALSE, title.size = 1.5)








































