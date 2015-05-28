# Created by Timothy Johnson. Last updated: 05/28/2015
#This script gets the area of each cell of a large raster. 
  
#set working directory where 1km grid is located. 
setwd("F:/TimData/SPAM/Ethiopia/1km2Grid")
#clear all variables
rm(list=ls())

#install useful packages (although many not needed) 
install.packages(c("spatstat","maptools","lattice","sp","RColorBrewer","splancs","maps", "plyr"))
install.packages(c("rgdal","raster","R.utils","spsurvey", "xlsx", "rJava", "foreign", "stringr", "gdata", "geosphere"),dep=TRUE)

#load libraries
library(spatstat); library(maptools); library(lattice); library(sp); 
library(RColorBrewer); library(splancs); library(maps)
library(rgdal); library(raster); library(R.utils); library(spsurvey); library(foreign);
library(rJava)
library(xlsx)
library(plyr)
library(stringr)
library(gdata)
library(geosphere)

#Read 1km raster containing cells for whole country (change filename to what you named it)
kmgrid = readGDAL("1km2_Ethiopiabufferclip_uniquenumbers.tif")

##convert 1km raster to data frame
kmgridx= as.data.frame(kmgrid, row.names=NULL, optional=FALSE, xy=FALSE, na.rm=TRUE)

#read raster as raster
r = raster(kmgrid)

#get area of each cell in raster
a = area(r)

#Create the area grid as a spatial data frame
spgdf2 = as(a, 'SpatialGridDataFrame')

#convert to normal dataframe
areadf= as.data.frame(spgdf2, row.names=NULL, optional=FALSE, xy=FALSE, na.rm=TRUE)

#change names so that it can be merged with the countrywide raster to match to cell 1km2 numbers
names(areadf)[names(areadf)=="s1"] = "x"
names(areadf)[names(areadf)=="s2"] = "y"

#get summary of both data frames to make sure they have common column names
summary(areadf)
summary(kmgridx)

#merge the dataframes
total = merge(kmgridx, areadf, by = c("x", "y"))

#write merged dataframe to stata file
write.dta(total, "NewCellSizeGridCombined.dta")










