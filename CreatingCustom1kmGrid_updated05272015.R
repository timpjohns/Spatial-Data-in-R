# Created by Timothy Johnson. Last updated: 03/23/2015

# This script creates a 1km SPAM grid that is uniquely numbered. Each 1km grid number keeps the same grid 
# number as the 5m grid but adds the number 1-100 at the end. For example, 5m cell 
# 3869014 has 100 1km2 cells: 3869014001, 3869014002….3869014100. Preparation work is required first and at the end 
# which is not included below. Everything could be done in R but I found it easier to work in ArcGIS at times.    
 
# To start, first project the 5m grid to WGS84. Then clip the 5m grid to a buffer around the country 
# of interest. The buffer ensures that cells on the border of the country will be included in the clip. 
# Then, resample the 5m grid so that the X and Y coordinates are the same. Resample to 0.083333, 0.083333.
# This ensures that the new 1km grid will align properly. Next, resample the new 0.083333 x 0.083333 grid
# to 1km (0.0083333 x 0.0083333). This grid will be used in the script below.  

#set working directory where 1km grid is located. 
setwd("F:/TimData/SPAM/Ethiopia/1km2Grid")
#clear all variables
rm(list=ls())

#install useful packages (although many not needed) 
install.packages(c("spatstat","maptools","lattice","sp","RColorBrewer","splancs","maps", "plyr"))
install.packages(c("rgdal","raster","R.utils","spsurvey", "xlsx", "rJava", "foreign", "stringr"),dep=TRUE)

#load libraries
library(spatstat); library(maptools); library(lattice); library(sp); 
library(RColorBrewer); library(splancs); library(maps)
library(rgdal); library(raster); library(R.utils); library(spsurvey); library(foreign);
library(rJava)
library(xlsx)
library(plyr)
library(stringr)

#Read 1km raster (change filename to what you named it)
kmgrid = readGDAL("1km2_Ethiopiabufferclip.tif")

##convert 1km raster to data frame
kmgridx= as.data.frame(kmgrid, row.names=NULL, optional=FALSE, xy=FALSE, na.rm=TRUE)

#sort by all three columns in this order: band1, y, x. This
##ensures that the data will all be renamed in the same way starting in the lower left corner.  
sortedGrid = kmgridx[with(kmgridx, order(band1, y, x)), ]
sort

##view that column of interest, make sure it is reading properly (optional) 
sortedGrid$band1

##Specify column of interest as y. Read numbers as character to use in script below
y = as.character(sortedGrid$band1)

##For each number in column y, paste a string of 001 to 100 
yy = unname(unlist(tapply(y, y, function(x)paste0(x, str_pad(1:length(x), 3, pad = "0")))))

##view data
yy

##convert string back to number
xx = as.numeric(yy)

##Merge created 1km2 unique numbers to sorted grid, so that each unique number now has X/Y point
dfmerge = cbind(xx, sortedGrid)

##export to comma separated text file to load into ArcGIS as points. Convert points to raster, snapping to the 5m grid and setting cell size to 1km. Also make sure values are
## set to newly converted numbers. Newly converted 1km raster should align with cell 5m.  
write.csv(dfmerge, file = "new1km2numbers.csv")



