#! /usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
fusoOrario=as.numeric(as.character(args[1]))
posto=as.character(args[2])


#management of several points per site!
#giving to preproc phase ;)
#If it happens they are going to drive back big rains and rad

library(RNetCDF)
##########
#RAIN & RAD
##########
ncra<-open.nc("rain.ncdf")

time_coord2 <- var.get.nc(ncra, "time")-fusoOrario
time_unit2 <- att.get.nc(ncra, "time", "units")
timeMatr<-utcal.nc(time_unit2, time_coord2)
timedf<-data.frame(data=paste(timeMatr[,3],timeMatr[,2],timeMatr[,1],sep="/"))#,anno=timeMatr[,1])
timedf$doy<-strptime(timedf$data,format="%d/%m/%Y")$yday+1
timedf$anno<-strptime(timedf$data,format="%d/%m/%Y")$year+1900



#handling rain
raoffset<-att.get.nc(ncra,"tp","add_offset")
rascale<-att.get.nc(ncra,"tp","scale_factor")
rana<-att.get.nc(ncra,"tp","missing_value")
rafv<-att.get.nc(ncra,"tp","_FillValue")



pt<-var.get.nc(ncra,"tp")
pt[pt==rana]<-NA
pt[pt==rafv]<-NA
#scaling, centering
pt<-pt*rascale+raoffset

timedf$rain<-pt*1000
pt<-NULL


#handling radiation
radoffset<-att.get.nc(ncra,"ssrd","add_offset")
radscale<-att.get.nc(ncra,"ssrd","scale_factor")
radna<-att.get.nc(ncra,"ssrd","missing_value")
radfv<-att.get.nc(ncra,"ssrd","_FillValue")

rad<-var.get.nc(ncra,"ssrd")
rad[rad==radna]<-NA
rad[rad==radfv]<-NA
#scaling, centering
rad<-rad*radscale+radoffset

#moving to GJ/m2
timedf$rad<-rad/1000000
rad<-NULL

close.nc(ncra)
############
#T2_D2M_forecast
############


t2nc<-open.nc("ttduv.ncdf")

time_coord2t <- var.get.nc(t2nc, "time")-fusoOrario
time_unit2t <- att.get.nc(t2nc, "time", "units")
timeMatrt<-utcal.nc(time_unit2t, time_coord2t)
timedft<-data.frame(data=paste(timeMatrt[,3],timeMatrt[,2],timeMatrt[,1],sep="/"))#,anno=timeMatrt[,1])
timedft$doy<-strptime(timedft$data,format="%d/%m/%Y")$yday+1
timedft$anno<-strptime(timedft$data,format="%d/%m/%Y")$year+1900


#handling temperature
t2moffset<-att.get.nc(t2nc,"t2m","add_offset")
t2mscale<-att.get.nc(t2nc,"t2m","scale_factor")
t2mna<-att.get.nc(t2nc,"t2m","missing_value")
t2mfv<-att.get.nc(t2nc,"t2m","_FillValue")

t2m<-var.get.nc(t2nc,"t2m")
t2m[t2m==t2mna]<-NA
t2m[t2m==t2mfv]<-NA
#scaling, centering and moving to celsius
t2m<-t2m*t2mscale+t2moffset - 273.15 


timedft$t2m<-t2m
t2m<-NULL

#handling HUMID
d2moffset<-att.get.nc(t2nc,"d2m","add_offset")
d2mscale<-att.get.nc(t2nc,"d2m","scale_factor")
d2mna<-att.get.nc(t2nc,"d2m","missing_value")
d2mfv<-att.get.nc(t2nc,"d2m","_FillValue")

d2m<-var.get.nc(t2nc,"d2m")
d2m[d2m==d2mna]<-NA
d2m[d2m==d2mfv]<-NA
#scaling, centering and moving to celsius
d2m<-d2m*d2mscale+d2moffset  - 273.15 

timedft$d2m<-d2m
d2m<-NULL


######
#WIND ISSUES
#IT HAS VECTORIAL COMPONENTS
#handling zonal
u10offset<-att.get.nc(t2nc,"u10","add_offset")
u10scale<-att.get.nc(t2nc,"u10","scale_factor")
u10na<-att.get.nc(t2nc,"u10","missing_value")
u10fv<-att.get.nc(t2nc,"u10","_FillValue")

u10<-var.get.nc(t2nc,"u10")
u10[u10==u10na]<-NA
u10[u10==u10fv]<-NA
#scaling, centering
u10<-u10*u10scale+u10offset


timedft$u10<-u10
u10<-NULL

#handling meridional
v10offset<-att.get.nc(t2nc,"v10","add_offset")
v10scale<-att.get.nc(t2nc,"v10","scale_factor")
v10na<-att.get.nc(t2nc,"v10","missing_value")
v10fv<-att.get.nc(t2nc,"v10","_FillValue")

v10<-var.get.nc(t2nc,"v10")
v10[v10==v10na]<-NA
v10[v10==v10fv]<-NA
#scaling, centering
v10<-v10*v10scale+v10offset

timedft$v10<-v10
v10<-NULL


close.nc(t2nc)


####
#everithing happly stored in timedf and timedft (having different timelapse)

#preparing df for export
timeFrames<-c(as.character(timedf$data),as.character(timedft$data))
timeFrames<-unique(timeFrames)
objTF<-strptime(timeFrames,format="%d/%m/%Y")

headMeteo<-data.frame(data=timeFrames[order(objTF)],
	anno<-objTF$year+1900,
	doy<-objTF$yday+1)
	
futmeteo<-matrix(rep(NA,times=(7*length(headMeteo[,1]))),ncol=7)


scumulo<-function(x){
#	soglia<-(24/length(x))*0.1
#	gradino<-rep(NA,length(x))
#	gradino[1]<-x[1]
#	for(enne in 2:length(x)){
#		if(gradino[enne-1]<soglia){
#			gradino[enne]<-x[enne]
#		}else{
#		gradino[enne]<-max(x[enne]-x[enne-1],0)	
#		}
#	}
#	return(sum(gradino))
	return(sum(x[c(length(x),length(x)/2)]))
}

dew2urZ<-function(vtem,vtdp){
	#not working!!!
	relHum<-rep(NA,length(vtem))
	for(step in 1:length(vtem)){
		tem<-vtem[step]
		tdp<-vtdp[step]
		#enhancing from Magnus formula to Buck, Arden L. (1981) equation (error <=0.06%)
		if(tem>=0){
			a<-6.1121
			b<-17.368
			c<-238.88
		}else{
			a<-6.1121
			b<-17.966
			c<-247.15
		}
		
		actVapPr<-exp((tdp*b)/(tdp+c))*a
		satVapPr<-a*exp(b*tem/(tem+c))
		relHum[step]<-actVapPr/satVapPr
	
	}
	return(relHum)
}


dew2ur<-function(vtem,vtdp){
	#100*(EXP((17.625*TD)/(243.04+TD))/EXP((17.625*T)/(243.04+T)))
	relHum<-rep(NA,length(vtem))
	b<-	17.625
	c<- 243.04
	for(step in 1:length(vtem)){
		tem<-vtem[step]
		tdp<-vtdp[step]
		relHum[step]<-100*(exp((b*tdp)/(c+tdp))/exp((b*tem)/(c+tem)))
	}
	return(relHum)
}


giornaliero<-function(anno,giorno){
		#subsetting the required data
		rara<-timedf[timedf$anno==anno&timedf$doy==giorno,]
		ttd<-timedft[timedft$anno==anno&timedft$doy==giorno,]
		UR<-dew2ur(ttd$t2m,ttd$d2m)
		#collecting output variables
		Rain<-scumulo(rara$rain)
		Rad<-scumulo(rara$rad)
		RHmin<-min(UR)
		RHmax<-max(UR)
		Tmin<-min(ttd$t2m)
		Tmax<-max(ttd$t2m)
		Wind<-mean(sqrt(ttd$v10^2+ttd$u10^2))
		return(as.numeric(c(Tmax,Tmin,Rain,Rad,RHmax,RHmin,Wind)))
}

for(x in 1:length(headMeteo[,1])){
	futmeteo[x,]<-giornaliero(headMeteo$anno[x],headMeteo$doy[x])
}

meteo<-data.frame(data=as.character(headMeteo$data),
	year=headMeteo$anno,DOY=headMeteo$doy,
	Tmax<-futmeteo[,1], Tmin<-futmeteo[,2], Rain<-futmeteo[,3], Rad<-futmeteo[,4],RHmax<-futmeteo[,5],RHmin<-futmeteo[,6],Vento<-futmeteo[,7])

names(meteo)<-c("Date","Year","Doy","Tmax","Tmin","Rain","Rad","RHmax","RHmin","Wind")


write.table(meteo,paste(posto,".dat",sep=""),eol = "\r\n",row.names=F,sep="\t",quote=F)
zip("/home/cassandra/Desktop/fileMeteo.zip",paste(posto,".dat",sep=""))
