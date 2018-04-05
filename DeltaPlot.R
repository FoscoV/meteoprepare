#! /usr/bin/R
#source("deltabehav.R")
#source("deltaPRbehav.R")

behav45<-function(mesa){
gigis<-raster(Monthbase45(mesa)-Monthbase(mesa))
hadley<-raster(MonthbaseH45(mesa)-MonthbaseH(mesa))
gigis<-resample(gigis,hadley)
#locator(n=1)
deltadelta<-gigis-hadley
extent(deltadelta)<-extent(0,360,-90,90)
return(deltadelta)
}


behavPR45<-function(mesa){
gigisP<-raster(MonthPRbase45(mesa)-MonthPRbase(mesa))*(3600*24)
hadleyP<-raster(MonthPRbaseH45(mesa)-MonthPRbaseH(mesa))*(3600*24)
gigisP<-resample(gigisP,hadleyP)
#locator(n=1)
deltadeltaP<-gigisP-hadleyP
extent(deltadeltaP)<-extent(0,360,-90,90)
return(deltadeltaP)
}



DeltaPlot45<-function(loop){
	for(mesa in rep(seq(1,12),loop)){
		dev.set(2)
		image(behavPR45(mesa),main=paste("Dgiss-Dhad (mm/giorno) rain: mese",mesa),zlim=c(-15,15),col=rainbow(31))
		raster:::.imageplot(1:2,1:2,c(-15,15),zlim=c(-15,15),legend.only=TRUE,col=rainbow(31))
		map('world2',add=T)

		dev.set(3)
		image(behav45(mesa),main=paste("Dgiss-Dhad (°K): mese",mesa),zlim=c(-15,15),col=rainbow(31))
		raster:::.imageplot(1:2,1:2,c(-15,15),zlim=c(-15,15),legend.only=TRUE,col=rainbow(31))
		map('world2',add=T)
		locator(n=1)
	}
}



behav85<-function(mesa){
gigis<-raster(Monthbase85(mesa)-Monthbase(mesa))
hadley<-raster(MonthbaseH85(mesa)-MonthbaseH(mesa))
gigis<-resample(gigis,hadley)
#locator(n=1)
deltadelta<-gigis-hadley
extent(deltadelta)<-extent(0,360,-90,90)
return(deltadelta)
}


behavPR85<-function(mesa){
gigisP<-raster(MonthPRbase85(mesa)-MonthPRbase(mesa))*(3600*24)
hadleyP<-raster(MonthPRbaseH85(mesa)-MonthPRbaseH(mesa))*(3600*24)
gigisP<-resample(gigisP,hadleyP)
#locator(n=1)
deltadeltaP<-gigisP-hadleyP
extent(deltadeltaP)<-extent(0,360,-90,90)
return(deltadeltaP)
}



DeltaPlot85<-function(loop){
	for(mesa in rep(seq(1,12),loop)){
		dev.set(2)
		image(behavPR85(mesa),main=paste("Dgiss-Dhad (mm/giorno) rain: mese",mesa),zlim=c(-15,15),col=rainbow(30))
		raster:::.imageplot(1:2,1:2,c(-15,15),zlim=c(-15,15),legend.only=TRUE,col=rainbow(30))
		map('world2',add=T)

		dev.set(3)
		image(behav85(mesa),main=paste("Dgiss-Dhad (°K): mese",mesa),zlim=c(-15,15),col=rainbow(30))
		raster:::.imageplot(1:2,1:2,c(-15,15),zlim=c(-15,15),legend.only=TRUE,col=rainbow(30))
		map('world2',add=T)
		locator(n=1)
	}
}
