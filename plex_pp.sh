#! /bin/bash
#
# Plex DVR Postprocessing
# Version 0.0.1
# twitter.com/thatvirtualboy
# www.thatvirtualboy.com
#

# FIRST, RUN COMCUT TO REMOVE COMMERCIALS, THEN TRANSCODE AND COMPRESS

lockFile='/tmp/dvrProcessing.lock'
inFile="$1"
tmpFile="$1.mp4"
dvrPostLog='/tmp/dvrProcessing.log'
time=`date '+%Y-%m-%d %H:%M:%S'`
handbrake=/PATH/TO/YOUR/INSTALL (mine is /usr/bin/HandBrakeCLI)
cut=/PATH/TO/YOUR/COMCUT/INSTALL (mine is /home/ryan/comchap/comcut)

echo "'$time' Plex DVR Postprocessing script started" | tee $dvrPostLog

# Check if post processing is already running
while [ -f $lockFile ]
do
    echo "'$time' $lockFile' exists, sleeping processing of '$inFile'" | tee -a $dvrPostLog
    sleep 10
done

# Create lock file to prevent other post-processing from running simultaneously
echo "'$time' Creating lock file for processing '$inFile'" | tee -a $dvrPostLog
touch $lockFile

# Run comcut
echo "'$time' Comcut started on '$inFile'" | tee -a $dvrPostLog
$cut "$inFile"

# Encode file to MP4 with handbrake-cli
echo "'$time' Transcoding started on '$inFile'" | tee -a $dvrPostLog
$handbrake -i "$inFile" -o "$tmpFile" --preset="Apple 1080p30 Surround" --encoder-preset="veryfast" -O

# Overwrite original ts file with the transcoded file
echo "'$time' File rename started" | tee -a $dvrPostLog
mv -f "$tmpFile" "$inFile"

#Remove lock file
echo "'$time' All done! Removing lock for '$inFile'" | tee -a $dvrPostLog
rm $lockFile

exit 0
