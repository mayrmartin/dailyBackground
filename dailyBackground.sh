#!/bin/bash

#This script pulls the daily wallpaper from bing.com and sets it as background.
#If the PC is offline, the script will use the last downloaded image.


market="en-US" #The available regions are: en-US,zh-CN,ja-JP,en-AU,en-UK,de-DE,en-NZ.
resolution="1920x1080" #The aviable resolutions are: 1366×768, 1920×1080, 1920×1200.
imageFileName=".wallpaper.jpg"
downloadDirectory="$HOME"

sleep 5 #If you launch the script automatically on startup, it's necessary that the script waits x seconds while the PC ties to establish an internet connection

wget -q --tries=2 --timeout=5 --spider http://google.com
if [[ $? -eq 0 ]]; then
        xml=$(curl -k --silent "https://www.bing.com/HPImageArchive.aspx?format=xml&idx=0&n=1&mkt=$market")
	baseURL=$(grep -oPm1 "(?<=<url>)[^<]+" <<< "$xml")
	
	imageLink=$(echo "$baseURL" | sed -n "s/1366x768/$resolution/gp")

	wget https://www.bing.com/$imageLink -O $downloadDirectory/$imageFileName
	gsettings set org.gnome.desktop.background picture-uri file:///$downloadDirectory/$imageFileName
else
       gsettings set org.gnome.desktop.background picture-uri file:///$downloadDirectory/$imageFileName
fi



