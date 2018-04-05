#! /bin/R
library(RCMIP5)

temperaB<- filterDimensions(loadCMIP5(variable="tas",experiment="historical",yearRange=c(1951,2005),model="GISS-E2-R"),lonRange=c(45,47),latRange=c(8,9))
tempera26<- filterDimensions(loadCMIP5(variable="tas",experiment="rcp45",yearRange=c(2006,2100),model="GISS-E2-R"),lonRange=c(45,47),latRange=c(8,9))

temperaGiss<-data.frame(mod="historical",time=temperaB$val$time,temp=temperaB$val$value)
temperaGiss<-rbind(temperaGiss,data.frame(mod="26",time=tempera26$val$time,temp=tempera26$val$value))

plot(stl(ts(temperaGiss$temp,start=1,frequency=12),s.window="periodic"))
#plot(stl(ts(temperaGiss$temp,start=1,frequency=12),s.window=20*12))
abline(v=length(temperaB$val$value)/12,col="red")
abline(v=length(temperaB$val$value)/12+12,col="cyan")

#secondiMese<-c(31,28,31,30,31,30,31,31,30,31,30,31)*3600*24


timeSER<-stl(ts(temperaGiss$temp,start=1,frequency=12),s.window="periodic")
anova(lm(timeSER$time.series[,2] ~  seq(1,125*12)))
dev.new()
ggplot(data=data.frame(temp=timeSER$time.series[,2],time=seq(1,125,length.out=125*12)),aes(x=time,y=temp))+geom_smooth(method="loess")+geom_line()

scartiSerie<-data.frame(mese=rep(c("01","02","03","04","05","06","07","08","09","10","11","12"),125),temp=as.vector(timeSER$time.series[,3]),anno=trunc(seq(1,125,length.out=125*12)))
ggplot(data=scartiSerie,aes(x=anno,y=temp,group=mese))+geom_smooth(method="loess",aes(col=mese),se=F)

#ggplot(data=subset(scartiSerie,scartiSerie$mese=="07"),aes(x=anno,y=temp,group=mese))+geom_smooth(method="loess",aes(col=mese),se=F)+geom_line()
