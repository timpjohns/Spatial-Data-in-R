# Created by Timothy Johnson. Last updated: 03/23/2015

# This script creates a 1km grid that is uniquely numbered. Each 1km grid number keeps the same grid 
# number as the 10km grid but adds the number 1-100 at the end. For example, 10km cell 
# 3869014 has 100 1km2 cells: 3869014001, 3869014002….3869014100. Preparation work is required first, 
# in the middle of the script, and at the end which is not included below. Everything could be done in R
# but I found it easier to work in ArcGIS and Stata at times.    
 
# To start, first project the 10km grid to WGS84. Then clip the 10km grid to a buffer around the country 
# of interest. The buffer ensures that cells on the border of the country will be included in the clip. 
# Then, resample the 10km grid so that the X and Y coordinates are the same. Resample to 0.083333, 0.083333.
# This ensures that the new 1km grid will align properly. Next, resample the new 0.083333 x 0.083333 grid
# to 1km (0.0083333 x 0.0083333). This grid will be used in the script below.  

#set working directory where 1km grid is located. 
setwd("F:/TimData/SPAM/Ethiopia/New1kmGrid")
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
kmgrid = readGDAL("Ethiopia_1km_spatiallyAlignedSnap2.tif")

##convert 1km raster to data frame
kmgridx= as.data.frame(kmgrid, row.names=NULL, optional=FALSE, xy=FALSE, na.rm=TRUE)

##write 1km grid to stata file so that this data can be sorted (probably could also do in R)
write.dta(kmgridx, "NewSPAMPixels_1kmgrid.dta")

###Next, open this statafile in stata and sort by all three columns in this order: band1, y, x. This
##ensures that the data will all be renamed in the same way starting in the lower left corner.  

##Read in sorted stata data. Make sure you saved the newly sorted data as stata 12.  
sortedGrid = read.dta("NewSPAMPixels_1kmgridSorted_12.dta")

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

##convert vector back to dataframe
xxx= as.data.frame(xx, row.names=NULL, optional=FALSE, xy=FALSE, na.rm=TRUE)

##view dataframe
xxx

##export this data to Stata to merge(could also do in R)
write.dta(xxx, "NewSPAMPixels_convertednumbers.dta")

##Load both of the sorted file of nonconverted numbers and the newly created file showing new numbers
##in stata. Copy all numbers of the converted numbers in "NewSPAMPixels_convertednumbers.dta" file. Paste
## in "NewSPAMPixels_1kmgridSorted_12.dta" table. Make sure order is not changed/do not sort before
##merging. 

##Finally, export the newly merged stata table to comma separated text file. Load text file in ArcGIS as points. 
## Convert points to raster, snapping to the 5m grid and setting cell size to 1km. Also make sure values are
## set to newly converted numbers. Newly converted 1km raster should align with cell 5m.   



