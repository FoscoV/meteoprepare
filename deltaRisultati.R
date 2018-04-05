#library(deltaCMIP)

tuCSV<-read.csv("~/Desktop/dbSites.csv",header=F)
tuttiInput<-data.frame(luogo=tuCSV[,1],lat=tuCSV[,2],lon=tuCSV[,3])
source("/home/cassandra/climChag/deltaCMIP.R")
setwd("/home/cassandra/climChag/SCENARI_AR5/Scenari/")

for(posto in tuttiInput$luogo){
	lata<-tuttiInput$lat[which(tuttiInput$luogo==posto)]
	lona<-tuttiInput$lon[which(tuttiInput$luogo==posto)]
	for(scenCO in c("rcp45","rcp85")){
		#cat(posto," ",scenCO)
		#cat(c("\n","\t","giss","\n"))
		#print("pr")
		deltaCMIP(emission=scenCO,qualeFile="GISS-E2-R/Baseline/pr_Amon_GISS-E2-R_historical_r1i1p1_197601-200012.nc",latUTM=lata,lonUTM=lona,AnniRan=c(1986,2005),targetYear=2040,outFile=paste("/tmp/delta/",posto,"-",scenCO,"GISS-pr.csv",sep=""),prtOut=FALSE)
		#print("tas")
		deltaCMIP(emission=scenCO,qualeFile="GISS-E2-R/Baseline/tas_Amon_GISS-E2-R_historical_r1i1p1_197601-200012.nc",latUTM=lata,lonUTM=lona,AnniRan=c(1986,2005),targetYear=2040,outFile=paste("/tmp/delta/",posto,"-",scenCO,"GISS-tas.csv",sep=""),prtOut=FALSE)
		#cat(c("\n","\t","HadGEM","\n"))
		#print("tas")
		deltaCMIP(emission=scenCO,qualeFile="HadGEM2-ES/Baseline/tas_Amon_HadGEM2-ES_historical_r1i1p1_198412-200511.nc",latUTM=lata,lonUTM=lona,AnniRan=c(1986,2005),targetYear=2040,outFile=paste("/tmp/delta/",posto,"-",scenCO,"Had-tas.csv",sep=""),prtOut=FALSE)
		#print("pr")
		deltaCMIP(emission=scenCO,qualeFile="HadGEM2-ES/Baseline/pr_Amon_HadGEM2-ES_historical_r1i1p1_198412-200511.nc",latUTM=lata,lonUTM=lona,AnniRan=c(1986,2005),targetYear=2040,outFile=paste("/tmp/delta/",posto,"-",scenCO,"Had-pr.csv",sep=""),prtOut=FALSE)
	}
}
