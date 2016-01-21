# This script harvests geotagged Tweets
# Created by Timothy Johnson. Last updated: 1/16/2015

#set working directory
setwd("F:/TimData/R_Scripts")
#clear all variables
rm(list=ls())

#install packages
install.packages(c("spatstat","maptools","lattice","sp","RColorBrewer","splancs","maps", "plyr"))
install.packages(c("rgdal","raster","R.utils","spsurvey", "xlsx", "rJava", "foreign"),dep=TRUE)
install.packages(c("twitteR", "ROAuth", "RCurl", "streamR"))

#load libraries
library(spatstat); library(maptools); library(lattice); library(sp); 
library(RColorBrewer); library(splancs); library(maps)
library(rgdal); library(raster); library(R.utils); library(spsurvey); library(foreign);
library(rJava)
library(xlsx)
library(plyr)
library(twitteR)
library(ROAuth)
library(RCurl)
library(streamR)

download.file(url="http://curl.haxx.se/ca/cacert.pem",destfile="cacert.pem")

# Set constant requestURL
requestURL <- "https://api.twitter.com/oauth/request_token"

# Set constant accessURL
accessURL <- "https://api.twitter.com/oauth/access_token"

# Set constant authURL
authURL <- "https://api.twitter.com/oauth/authorize"

consumerKey = " "
consumerSecret = " "

twitCred = OAuthFactory$new(consumerKey=consumerKey,consumerSecret=consumerSecret,requestURL=requestURL,accessURL=accessURL,authURL=authURL)

# Asking for access
twitCred$handshake(cainfo="cacert.pem")

registerTwitterOAuth(twitCred)
save(list="twitCred", file="twitteR_credentials")


###############################################
Use to Stream Tweets after initial set-up
###############################################

# to load saved twitter authorization
# set up following the process at this page
# https://sites.google.com/site/dataminingatuoc/home/data-from-twitter/r-oauth-for-twitter

load("twitteR_credentials")
registerTwitterOAuth(twitCred)

tweets = filterStream(file.name="",track="snow", timeout=180, oauth=twitCred)
#,locations=c(-126,24,-65,49)

# To convert list to dataframe from filterStream
tweetsDF = parseTweets(tweets)

#select tweets with geocodes (use "lat" for stream "latitude" for search)
lltweets = subset(tweetsDF, lat!="NA")

map('usa')
points(lltweets$lon, lltweets$lat, pch=20,cex=1.5,col=rgb(0,0,1,0.3))
title("Snow Tweets")

write.table(lltweets, "snow.txt", sep="\t")
write.xlsx(lltweets, "snow.xlsx")


summary(lltweets)

###reading in data to map

#snowtxt= read.table("snow.csv", header=TRUE, sep=",", row.names="id")
snowtxt= read.table("snow.csv", header=TRUE, sep=",", fill="TRUE")
summary (snowtxt)


