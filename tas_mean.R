#read the nc
library(ncdf4.helpers)
library(PCICt)
library(ncdf4)
MeanTem<-function(file,latUTM,lonUTM,AnnoInizio,AnnoFine){
#pr7600<-nc_open("pr_Amon_GISS-E2-R_historical_r1i1p1_197601-200012.nc")
pr7600<-nc_open(file)
#just for trial, change with function's input
#latUTM<-30.98
#lonUTM<-75.82
#find ount mine lat and lon here
lata<-which(ncvar_get(pr7600,"lat_bnds")[1,]< latUTM & ncvar_get(pr7600,"lat_bnds")[2,]>latUTM)
longa<-which(ncvar_get(pr7600,"lon_bnds")[1,]< lonUTM & ncvar_get(pr7600,"lon_bnds")[2,]>lonUTM)

#now i've to deal with time...
#startDay<-as.Date(strsplit(ncatt_get(pr7600,"time")$units," ")[[1]][3])
#DayYear<-as.numeric(strsplit(ncatt_get(pr7600,"time")$calendar,"_")[[1]][1])

#trial, change with function's input
#AnnoInizio<-1985#as.Date("1985-1-1")
#AnnoFine <- 1999#as.Date("1999-12-31")


#check for JAN start
#not yet done, to do later!!



#StartPoint<-min(which(ncvar_get(pr7600,"time_bnds")[2,]>((length(seq(startDay,AnnoInizio,by="months"))-1)/12*DayYear)))
StartPoint<-which(as.numeric(strftime(nc.get.time.series(pr7600),format="%Y"))==AnnoInizio & as.numeric(strftime(nc.get.time.series(pr7600),format="%m")) == 01)
#EndPoint<-max(which(ncvar_get(pr7600,"time_bnds")[2,]>=((length(seq(startDay,AnnoFine,by="months"))-1)/12*DayYear)))
EndPoint<-which(as.numeric(strftime(nc.get.time.series(pr7600),format="%Y"))==AnnoFine & as.numeric(strftime(nc.get.time.series(pr7600),format="%m")) == 12)

#which frames do I need?
fugaceMomento<-seq(StartPoint,EndPoint)


#meet the start date
#monthly data! matrix and that's done!!)
#buono per temperatura\
MonthsINyears<-matrix(ncvar_get(pr7600,"tas")[longa,lata,fugaceMomento],nrow=12,byrow=FALSE)
#questo è perfezionato per le precipitazioni
milmetMese<-function(mese){
	secMon<-86400*(ncvar_get(pr7600,"time_bnds")[2,fugaceMomento[mese]]-ncvar_get(pr7600,"time_bnds")[1,fugaceMomento[mese]])
	stockMM<-ncvar_get(pr7600,"pr")[longa,lata,fugaceMomento[mese]]*secMon
	return(stockMM)
}
#MonthsINyears<-matrix(unlist(lapply(X=seq(1,length(fugaceMomento)),FUN=milmetMese)),nrow=12,byrow=FALSE)


mediaIntra<-function(mese){
	#buona per temperature!
	#meanth<-mean(MonthsINyears[mese,])
	meanth<-mean(MonthsINyears[mese,])
	return(meanth)
}
MediaPeriodo<-matrix(unlist(lapply(X=seq(1,12),FUN=mediaIntra)),nrow=12)
rownames(MediaPeriodo)<-c("J","F","M","A","M","J","J","A","S","O","N","D")


return(MediaPeriodo)
}