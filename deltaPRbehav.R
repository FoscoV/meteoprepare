library(ncdf4)
library(PCICt)
library(raster)
library(RCMIP5)
library(spatial.tools)
library(mapdata)
#for(mese in seq(1:140)){plot(raster(ncvar_get(hadgem1,"pr")[,,mese]))}


#baseline
Giss<-loadCMIP5(variable="pr",experiment="historical",yearRange=c(1986,2005),model="GISS-E2-R")
basepr<-RCMIP5::makeMonthlyStat(Giss)
MonthPRbase<-function(mese){return(matrix(basepr$val$value[which(basepr$val$time ==mese)],nrow=length(unique(basepr$val$lat)),byrow=F))}
latg<-length(MonthPRbase(1)[,1])
MonthPRbase<-function(mese){return(matrix(basepr$val$value[which(basepr$val$time ==mese)],nrow=length(unique(basepr$val$lat)),byrow=F)[latg:1,])}

HadGEM<-loadCMIP5(variable="pr",experiment="historical",yearRange=c(1986,2005),model="HadGEM2-ES")
baseprH<-RCMIP5::makeMonthlyStat(HadGEM)
MonthPRbaseH<-function(mese){return(matrix(baseprH$val$value[which(baseprH$val$time ==mese)],nrow=length(unique(baseprH$val$lat)),byrow=F))}
lath<-length(MonthPRbaseH(1)[,1])
MonthPRbaseH<-function(mese){return(matrix(baseprH$val$value[which(baseprH$val$time ==mese)],nrow=length(unique(baseprH$val$lat)),byrow=F)[lath:1,])}

#RCP45
Giss<-loadCMIP5(variable="pr",experiment="rcp45",yearRange=c(2030,2049),model="GISS-E2-R")
pr45<-RCMIP5::makeMonthlyStat(Giss)
MonthPRbase45<-function(mese){return(matrix(pr45$val$value[which(pr45$val$time ==mese)],nrow=length(unique(pr45$val$lat)),byrow=F)[latg:1,])}

HadGEM<-loadCMIP5(variable="pr",experiment="rcp45",yearRange=c(2030,2049),model="HadGEM2-ES")
prH45<-RCMIP5::makeMonthlyStat(HadGEM)
MonthPRbaseH45<-function(mese){return(matrix(prH45$val$value[which(prH45$val$time ==mese)],nrow=length(unique(prH45$val$lat)),byrow=F)[lath:1,])}


#RCP85
Giss<-loadCMIP5(variable="pr",experiment="rcp85",yearRange=c(2030,2049),model="GISS-E2-R")
pr85<-RCMIP5::makeMonthlyStat(Giss)
MonthPRbase85<-function(mese){return(matrix(pr85$val$value[which(pr85$val$time ==mese)],nrow=length(unique(pr85$val$lat)),byrow=F)[latg:1,])}

HadGEM<-loadCMIP5(variable="pr",experiment="rcp85",yearRange=c(2030,2049),model="HadGEM2-ES")
prH85<-RCMIP5::makeMonthlyStat(HadGEM)
MonthPRbaseH85<-function(mese){return(matrix(prH85$val$value[which(prH85$val$time ==mese)],nrow=length(unique(prH85$val$lat)),byrow=F)[lath:1,])}

#plot()

#image(deltadeltaP,main=paste("Dgiss-Dhad (mm/giorno) rain: mese",mesa),zlim=c(-15,15),col=rainbow(30))
#raster:::.imageplot(1:2,1:2,c(-15,15),zlim=c(-15,15),legend.only=TRUE,col=rainbow(30))
#map('world2',add=T)
#}

#DeltaPlot45<-function(loop){
#	for(mesa in rep(seq(1,12),loop)){
#		dev.set(2)
#		image(behavPR(mesa),main=paste("Dgiss-Dhad (mm/giorno) rain: mese",mesa),zlim=c(-15,15),col=rainbow(30))
#		raster:::.imageplot(1:2,1:2,c(-15,15),zlim=c(-15,15),legend.only=TRUE,col=rainbow(30))
#		map('world2',add=T)

#		dev.set(3)
#		image(behav(mesa),main=paste("Dgiss-Dhad (°K): mese",mesa),zlim=c(-15,15),col=rainbow(30))
#		raster:::.imageplot(1:2,1:2,c(-15,15),zlim=c(-15,15),legend.only=TRUE,col=rainbow(30))
#		map('world2',add=T)
#		locator(n=1)
#	}
#}
