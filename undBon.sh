#! /bin/bash
cd /tmp/
unzip -u /home/cassandra/Downloads/DLmeteo.zip
rm /home/cassandra/Desktop/fileMeteo.zip
cd /home/cassandra/meteo
#./scriptGener.sh
mkdir /tmp/delta
nice -n 10 Rscript /home/cassandra/climChag/deltaRisultati.R &
for riga in $(cat /home/cassandra/Desktop/dbSites.csv)
do

	#echo $riga
	    posto=$(echo $riga | cut -d , -f 1)
	    cordNS=$(echo $riga | cut -d , -f 2)
	    cordOE=$(echo $riga | cut -d , -f 3)
		fusOra=$(echo $riga | cut -d , -f 4)
		datIni=$(echo $riga | cut -d , -f 5)
		datFine=$(echo $riga | cut -d , -f 6)
	
	mkdir $posto
	#mv /tmp/tmpRisultati/"$posto"_forecast_rain_rad.grb /home/cassandra/meteo/"$posto"
	grib_to_netcdf /tmp/tmpRisultati/"$posto"_forecast_rain_rad.grb -o /home/cassandra/meteo/"$posto"/rain.ncdf &
	pidgeonRain=$!
	#mv /tmp/tmpRisultati/"$posto"_forecast_t2m_td2m_uv10m.grb /home/cassandra/meteo/"$posto"
	grib_to_netcdf /tmp/tmpRisultati/"$posto"_forecast_t2m_td2m_uv10m.grb -o /home/cassandra/meteo/"$posto"/ttduv.ncdf
	#mv /tmp/tmpRisultati/"$posto"_analisi_t2m_td2m_uv10m.grb /home/cassandra/meteo/"$posto"
	#mv /tmp/tmpRisultati/"$posto"* /home/cassandra/meteo/"$posto"/
	wait $pidgeonRain
	echo $posto
	cd $posto
	
	Rscript ~/ecmwf.R $fusOra $posto &
	#mv meteo.dat output_$posto.dat
#	sbatch script_ecmwf_$posto.sh
#	./era2ascii.sh
	#zip -9 /home/cassandra/Desktop/fileMeteo.zip output_$posto.dat
	cd ../

done
rm -rf /home/cassandra/Downloads/DLmeteo*
cd /tmp/
zip -9 ~/Desktop/fileMeteo.zip delta/*
rm -r /tmp/delta
#./scriptGener.sh
