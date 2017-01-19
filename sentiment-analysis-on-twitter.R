
# source: http://thinktostart.com/sentiment-analysis-on-twitter/

library(twitteR)

# Twitter Authentication with R:
# las API keys y los token aquí: https://apps.twitter.com/

api_key <- "YAJlNzbrOuePpHLjkND1w"
api_secret <- "KH1yxTut32jD5ADN2g2D1ATioEH5BVOYeMCVvxMEs"
access_token <- "9232912-4URGmvirxQ6CF3WGenAarGpZ1pVq50pNILCo4B6J76"
access_token_secret <- "J4tzVYGrVUoEx6HXcJk7df1rGLtP9VelAnHsOzBUuPovJ"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

# Getting the data

tweets = searchTwitter("Marbella", n=200,  lang="en")

# To be able to analyze our tweets, we have to extract their text and save it
# into the variable tweets.text by typing:
  
Tweets.text = laply(tweets,function(t)t$getText())  

# remove all non graphical characters

usableText=str_replace_all(Tweets.text,"[^[:graph:]]", " ") 

# What we also need are our lists with the positive and the negative words.
# We can find them here:
# https://github.com/mjhea0/twitter-sentiment-analysis/tree/master/wordbanks

# After downloading the ZIP you can put them in a folder on your Computer; 
# you should just keep the absolute path in mind.

# We now have to load the words in variables to use them by typing:

pos = scan('Z:/Personales/Raul/R/wordbanks/positive-words.txt', what='character', comment.char=';')
neg = scan('Z:/Personales/Raul/R/wordbanks/negative-words.txt', what='character', comment.char=';')

# Now we have to insert a small algorhytm written by Jeffrey Breen analyzing our words.

score.sentiment = function(sentences, pos.words, neg.words, .progress='none'){
  
  require(plyr)
  require(stringr)
  
  # we got a vector of sentences. plyr will handle a list
  
  # or a vector as an "l" for us
  
  # we want a simple array ("a") of scores back, so we use
  
  # "l" + "a" + "ply" = "laply":
  
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    # clean up sentences with R's regex-driven global substitute, gsub():
    
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    
    # and convert to lower case:
    
    sentence = tolower(sentence)
    
    # split into words. str_split is in the stringr package
    
    word.list = str_split(sentence, '\\s+')
    
    # sometimes a list() is one level of hierarchy too much
    
    words = unlist(word.list)
    
    # compare our words to the dictionaries of positive & negative terms
    
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    # match() returns the position of the matched term or NA
    
    # we just want a TRUE/FALSE:
    
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    # and conveniently enough, TRUE/FALSE will be treated as 1/0 by sum():
    
    score = sum(pos.matches) - sum(neg.matches)
    return(score)
    
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  
  return(scores.df)
  
}

# The final steps:

analysis = score.sentiment(usableText, pos, neg)

# Congrats, your first sentiment Analysis was now saved.
# You can get a table by typing:

table(analysis$score)

# Or the mean by typing:
mean(analysis$score)

# Or get a histogram with:
hist(analysis$score)


# The positive values stand for positive tweets and the negative values 
# for negative tweets. The mean tells you about the overall mood of your sample.























