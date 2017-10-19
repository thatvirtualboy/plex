#! /bin/bash
#
# Plex DVR Postprocessing
# Version 0.0.1
# twitter.com/thatvirtualboy
# www.thatvirtualboy.com
#

# FIRST, RUN COMCUT TO REMOVE COMMERCIALS, THEN TRANSCODE AND COMPRESS

lockFile='/tmp/dvrProcessing.lock'
sourceFile="$1"
tempEncode="$1.mp4"
dvrPostLog='/tmp/dvrProcessing.log'
time=`date '+%Y-%m-%d %H:%M:%S'`
handbrake=/PATH/TO/YOUR/INSTALL (mine is /usr/bin/HandBrakeCLI)
cut=/PATH/TO/YOUR/COMCUT/INSTALL (mine is /home/ryan/comchap/comcut)

echo "'$time' Plex DVR Postprocessing script started" | tee $dvrPostLog

# Check if post processing is already running
while [ -f $lockFile ]
do
    echo "'$time' $lockFile' exists, sleeping processing of '$sourceFile'" | tee -a $dvrPostLog
    sleep 10
done

# Create lock file to prevent other post-processing from running simultaneously
echo "'$time' Creating lock file for processing '$sourceFile'" | tee -a $dvrPostLog
touch $lockFile

# Run comcut
echo "'$time' Comcut started on '$sourceFile'" | tee -a $dvrPostLog
$cut "$sourceFile"

# Encode file to MP4 with handbrake-cli
echo "'$time' Transcoding started on '$sourceFile'" | tee -a $dvrPostLog
$handbrake -i "$sourceFile" -o "$tempEncode" --preset="Apple 1080p30 Surround" --encoder-preset="veryfast"

# Overwrite original ts file with the transcoded file
echo "'$time' File rename started" | tee -a $dvrPostLog
mv -f "$tempEncode" "$sourceFile"

#Remove lock file
echo "'$time' Done processing '$sourceFile' Removing lock" | tee -a $dvrPostLog
rm $lockFile

exit 0
