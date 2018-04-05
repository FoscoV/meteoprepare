#! /usr/bin/R
library(ncdf4.helpers)
library(PCICt)
library(ncdf4)
library(RCMIP5)


deltaCMIP<-function(qualeFile,latUTM,lonUTM,AnniRan,targetYear,outFile,emission,variable,modello,prtOut=TRUE){


#I need this file: lat\lon_bnds are stored here
if(missing(qualeFile)){
	cat(c("Quale Baseline?"))
	qualeFile<-file.choose()
}
#wondering if batch acquire datas concerning the analysis or get them by helpers
if(missing(variable)|missing(modello)){
	cmipcinque<-get.split.filename.cmip5(qualeFile)
}else{
	cmipcinque<-c(variable,"tres",modello,emission)
}
#here are the georeferenced issues i mentioned above
ilFile<-nc_open(qualeFile)
if(missing(latUTM)){
	cat(c("Latitudine?"))
	latUTM<-scan(,nmax=1)
}
if(missing(lonUTM)){
	cat(c("Longitudine?"))
	lonUTM<-scan(,nmax=1)
}
if(missing(AnniRan)){
	cat(c("Anni della BaseLine?"))
	AnniRan<-scan(,nmax=2)
}
lata<-which(ncvar_get(ilFile,"lat_bnds")[1,]<= latUTM & ncvar_get(ilFile,"lat_bnds")[2,]>=latUTM)
#arranging some issues with negative longitudes
if(lonUTM < min(ncvar_get(ilFile,"lon_bnds")[1,])){
	longa<-which((ncvar_get(ilFile,"lon_bnds")[1,])<= (360+lonUTM) & (ncvar_get(ilFile,"lon_bnds")[2,])>(360+lonUTM))
}else{longa<-which(ncvar_get(ilFile,"lon_bnds")[1,]<= lonUTM & ncvar_get(ilFile,"lon_bnds")[2,]>lonUTM)}


#Monthly mean... it depends on scenario and years: variabe and model come from the general settings.
meanth<-function(ANNI,emis){
	varALL<-loadCMIP5(variable=cmipcinque[1],model=cmipcinque[3],experiment=emis,yearRange=ANNI)
	varSOME<-filterDimensions(varALL,lonRange=ncvar_get(ilFile,"lon_bnds")[,longa],latRange=ncvar_get(ilFile,"lat_bnds")[,lata])
	varVAL<-makeMonthlyStat(varSOME)
	return(varVAL$val[4])
}

#monthly mean on baseline year ("historrical" by defition"
baseLine<-meanth(AnniRan,"historical")


if(missing(emission)){
	cat("Quale file per il target?")
	emission<-get.split.filename.cmip5(file.choose())[4]
}

if(missing(targetYear)){
	cat(c("A quale anno?"))
	targetYear<-scan(,nmax=1)
}
AltriAnni<-c((targetYear-diff(AnniRan)/2),(targetYear+diff(AnniRan)/2))
#monthly mean on emission scenario and targetYear
target<-meanth(AltriAnni,emission)

#preparing results for output
RESULTS<-cbind(as.matrix(baseLine),as.matrix(target))
#imbelletting with month names.
rownames(RESULTS)<-c("J","F","M","A","M","J","J","A","S","O","N","D")


#here some issues are going to appear... I would bet that some deeper understanding about month's length should be done...
if(cmipcinque[1]=="pr"){
	#I'm going to know what's thee first day accounted in the baseline
	StartPoint<-which(as.numeric(strftime(nc.get.time.series(ilFile),format="%Y"))==min(AnniRan) & as.numeric(strftime(nc.get.time.series(ilFile),format="%m")) == 01)
##going to check how long it takes since the first day after tthe starting of the month and the last day...
	sequenzaMesi<-function(mese){
		lunghezza<-ncvar_get(ilFile,"time_bnds")[2,StartPoint+mese]-ncvar_get(ilFile,"time_bnds")[1,StartPoint+mese]
		return(lunghezza)
	}
	#obtaining an array of month's length
	lunghezzaMesi<-unlist(lapply(X=seq(0,11),FUN=sequenzaMesi))

	#RESULTS<-nc.get.time.multiplier("months")*RESULTS
	#seconds per month
	RESULTS<-lunghezzaMesi*86400*RESULTS
}

RESULTS<-cbind(RESULTS,as.matrix(RESULTS[,2]-RESULTS[,1]))
RESULTS<-cbind(RESULTS,as.matrix(RESULTS[,2]/RESULTS[,1]))

colnames(RESULTS)<-c("baseline",targetYear,"DIFF","FRAC")
if(missing(outFile)){
	cat(c("Dove vuoi salvare?"))
	outFile<-file.choose()
}
write.csv(RESULTS,file=outFile)
if(prtOut==TRUE){return(RESULTS)}
}
