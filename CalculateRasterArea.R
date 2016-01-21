# Created by Timothy Johnson. Last updated: 1/14/2016
#This script gets the area of each cell of a raster with option to either:
#1) create raster of cell sizes
#2) merge to input raster with stata table output
  
#set working directory where raster is located.  
setwd("F:/TimData/NRM_Technologies")
#clear all variables
rm(list=ls())

#install useful packages (although many not needed) 
install.packages(c("spatstat","maptools","sp","maps","rgdal","raster", "xlsx", "foreign","ff"),dep=TRUE)
#load libraries
library(spatstat); library(maptools); library(sp); library(maps)
library(rgdal); library(raster); library(foreign);library(xlsx); library(ff)

#Read raster (change filename to what you named it)
kmgrid = readGDAL("Agroforestry_crop_setnull.tif")

#convert 1km raster to data frame
kmgridx= as.data.frame(kmgrid, row.names=NULL, optional=FALSE, xy=FALSE, na.rm=TRUE)

#read raster as raster
r = raster(kmgrid)

#get area of each cell in raster
a = area(r)
#plot values if interested
plot(a)

####
###If you want to output to raster:
newras = writeRaster(a, filename="Agroforestry_crop_setnull_areas.tif", format="GTiff", overwrite=TRUE)


####
###if you want it in stata and linked to input raster values:
#Create the area grid as a spatial data frame
spgdf2 = as(a, 'SpatialGridDataFrame')

#convert to normal dataframe
areadf= as.data.frame(spgdf2, row.names=NULL, optional=FALSE, xy=FALSE, na.rm=TRUE)

#change names so that it can be merged with the original raster to match to cell raster values
names(areadf)[names(areadf)=="s1"] = "x"
names(areadf)[names(areadf)=="s2"] = "y"
names(kmgridx)[names(kmgridx)=="band1"] = "OrigRasValues"

#get summary of both data frames to make sure they have common column names
summary(areadf)
summary(kmgridx)

#merge the dataframes
total = merge(kmgridx, areadf, by = c("x", "y"))

#write merged dataframe to stata file
write.dta(total, "rasAreaData2.dta")










