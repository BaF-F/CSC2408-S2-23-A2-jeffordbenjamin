#!/bin/bash

# This is a script to organise recordings from dailydigest folder

# Define directories with relative paths
dailyingest_dir=${1:-dailyingest}
audio_dir=${2:-audio/}
byDate_dir=$audio_dir/byDate
byContributor_dir=$audio_dir/byContributor
byTopic_dir=$audio_dir/byTopic
badfiles_dir=badfiles

# Create directories if they don't exist
mkdir -p $byDate_dir
mkdir -p $byContributor_dir"/Mark"
mkdir -p $byContributor_dir"/Stan"
mkdir -p $byContributor_dir"/Livia"
mkdir -p $byTopic_dir"/business"
mkdir -p $byTopic_dir"/politics"
mkdir -p $byTopic_dir"/sport"
mkdir -p $byTopic_dir"/technology"
mkdir -p $badfiles_dir

# Process files in dailyingest
for file in $dailyingest_dir/*.*; do
    if [[ -f $file ]]; then


        # Extract information from the filename
        filename=$(basename "$file")
        date=$(echo $filename | cut -d'-' -f1)
        topic=$(echo $filename | cut -d'-' -f2)
        contributor=$(echo $filename | cut -d'-' -f3)
		
        
        # Check if contributor and topic are valid
        if [[ ($contributor == "Stan" || $contributor == "Livia" || $contributor == "Mark") &&
              ($topic == "sport" || $topic == "politics" || $topic == "business" || $topic == "technology") ]]; then
            # Move file to byDate directory
            mv "$file" "$byDate_dir"
			
            # Create a symbolic link in byContributor directory
            ln -s ../../../"$byDate_dir/$filename" "$byContributor_dir/$contributor/"

            ln -s ../../../"$byDate_dir/$filename" "$byTopic_dir/$topic/"

        else
            # If contributor or topic is invalid, move to badfiles directory
            mv "$file" "$badfiles_dir"
        fi
    fi


done