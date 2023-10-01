#!/bin/bash

# This is a script to compare weather conditions and internet speed

# Silence all output and errors
#exec &> /dev/null


# Define variables
csv_output="ipweatherdata.csv"
current_date=""
current_time=""
ipaddress=""
downspeed=""

# choose name of connection, in case of VPN or multiple networks
connection_name="wlp4s0"


# Check CSV exists and is writable
if [ ! -f $csv_output ]; then
    echo "Error: CSV file does not exist or is not writable."
    exit 404
fi


# Get time and date
current_date=`date +%Y-%m-%d`
echo $current_date

current_time=`date +%H:%M`
echo $current_time


# Get IP address
ipaddress=`ip addr show $connection_name | grep -oP 'inet \K[\d.]+'`
echo $ipaddress


# Get internet speed
#downspeed=`speedtest | grep -oP 'Download: \K[0-9.]+ [KMG]*bit/s'`
echo $downspeed


# Get weather conditions
weather=`curl wttr.in/Toowoomba?format=%p+%t+%P+%u`
echo $weather

IFS=' ' read -r precipitation temperature pressure uv_index <<< "$weather"
echo $temperature


# Output to a .csv file
echo "\"$current_date\",\"$current_time\",\"$ipaddress\",\"$downspeed\",\"$precipitation\",\"$temperature\",\"$pressure\",\"$uv_index\"" >> "$csv_output"