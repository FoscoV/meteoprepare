#!/bin/bash

rm -rf DLmeteo.zip
#cd ~/tmpRisultati/
for riga in $(cat meteo/dbSites.csv)
do
	echo $riga

	    posto=$(echo $riga | cut -d , -f 1)
	    cordNS=$(echo $riga | cut -d , -f 2)
	    cordOE=$(echo $riga | cut -d , -f 3)
		fusOra=$(echo $riga | cut -d , -f 4)
		datIni=$(echo $riga | cut -d , -f 5)
		datFine=$(echo $riga | cut -d , -f 6)
	zip -9 DLmeteo.zip ~/tmpRisultati/"$posto"_forecast_rain_rad.grb
	zip -9 DLmeteo.zip ~/tmpRisultati/"$posto"_forecast_t2m_td2m_uv10m.grb
	zip -9 DLmeteo.zip ~/tmpRisultati/"$posto"_analisi_t2m_td2m_uv10m.grb

done
echo "==========================="
echo "Scarica il file DLmeteo.zip"
echo "==========================="
