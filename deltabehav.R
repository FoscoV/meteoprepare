library(ncdf4)
library(PCICt)
library(raster)
library(RCMIP5)
library(spatial.tools)
#for(mese in seq(1:140)){plot(raster(ncvar_get(hadgem1,"tas")[,,mese]))}


#baseline
Giss<-loadCMIP5(variable="tas",experiment="historical",yearRange=c(1986,2005),model="GISS-E2-R")
baseTas<-RCMIP5::makeMonthlyStat(Giss)
Monthbase<-function(mese){return(matrix(baseTas$val$value[which(baseTas$val$time ==mese)],nrow=length(unique(baseTas$val$lat)),byrow=F))}
latg<-length(Monthbase(1)[,1])
Monthbase<-function(mese){return(matrix(baseTas$val$value[which(baseTas$val$time ==mese)],nrow=length(unique(baseTas$val$lat)),byrow=F)[latg:1,])}


HadGEM<-loadCMIP5(variable="tas",experiment="historical",yearRange=c(1986,2005),model="HadGEM2-ES")
baseTasH<-RCMIP5::makeMonthlyStat(HadGEM)
MonthbaseH<-function(mese){return(matrix(baseTasH$val$value[which(baseTasH$val$time ==mese)],nrow=length(unique(baseTasH$val$lat)),byrow=F))}
lath<-length(MonthbaseH(1)[,1])
MonthbaseH<-function(mese){return(matrix(baseTasH$val$value[which(baseTasH$val$time ==mese)],nrow=length(unique(baseTasH$val$lat)),byrow=F)[lath:1,])}


#RCP45
Giss<-loadCMIP5(variable="tas",experiment="rcp45",yearRange=c(2030,2049),model="GISS-E2-R")
Tas45<-RCMIP5::makeMonthlyStat(Giss)
Monthbase45<-function(mese){return(matrix(Tas45$val$value[which(Tas45$val$time ==mese)],nrow=length(unique(Tas45$val$lat)),byrow=F)[latg:1,])}

HadGEM<-loadCMIP5(variable="tas",experiment="rcp45",yearRange=c(2030,2049),model="HadGEM2-ES")
TasH45<-RCMIP5::makeMonthlyStat(HadGEM)
MonthbaseH45<-function(mese){return(matrix(TasH45$val$value[which(TasH45$val$time ==mese)],nrow=length(unique(TasH45$val$lat)),byrow=F)[lath:1,])}


#RCP85
Giss<-loadCMIP5(variable="tas",experiment="rcp85",yearRange=c(2030,2049),model="GISS-E2-R")
Tas85<-RCMIP5::makeMonthlyStat(Giss)
Monthbase85<-function(mese){return(matrix(Tas85$val$value[which(Tas85$val$time ==mese)],nrow=length(unique(Tas85$val$lat)),byrow=F)[latg:1,])}

HadGEM<-loadCMIP5(variable="tas",experiment="rcp85",yearRange=c(2030,2049),model="HadGEM2-ES")
TasH85<-RCMIP5::makeMonthlyStat(HadGEM)
MonthbaseH85<-function(mese){return(matrix(TasH85$val$value[which(TasH85$val$time ==mese)],nrow=length(unique(TasH85$val$lat)),byrow=F)[lath:1,])}




#image(deltadelta,main=paste("Dgiss-Dhad: mese",mesa),zlim=c(-15,15),col=rainbow(30))
#raster:::.imageplot(1:2,1:2,c(-15,15),zlim=c(-15,15),legend.only=TRUE,col=rainbow(30))
#map('world2',add=T)
#}

