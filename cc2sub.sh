#!/bin/bash
# this script extracts one subtitles from every video file in this directory and removes the closed caption comments in [], () or {}
#it creates an srt file next to the video file, it does not mux the subtitle into the video file
 #(check with ffmpeg -i [file.mkv]
# run with bash subs.sh or ./subs.sh not sh.subs.sh (line 26 and 27 does not work with dash)

#Requierments: dos2linux ffmpeg
#Author: Slomo17
#Version 1.0

###############Settings#########################
# select bracket type: 1:[] 2:() 3:{}
brackets=1
#select video file type
file_type=mkv
#select subtitle stream number (check with ffmpeg -i [file.mkv])
stream=6
#select language (for file name)
lang=en_US
##############################################

###############Script#########################
for f in ./*.$file_type; do

	#format filename for subtitle
	sub="${f%.*}"
	sub="${sub:2}.$lang"
	# run only if subtitle does not exist already
	if [ ! -f "$sub.srt" ]; then

		#extract subtitle (6 is the stream position of the subtitle you want)
		ffmpeg -i "$f" -map 0:$stream "$sub.srt"

		# convert to unix line ending
		dos2unix "$sub.srt"

		# remove everything in Brackets
		#sed -i "s/\[[^]]*\]//g" "$sub.srt"
		if [ "$brackets"==1 ]; then sed -i "s/\[[^]]*\]//g" "$sub.srt"	
		elif [ "$brackets"==2 ]; then sed -i "s/([^()]*)//g" "$sub.srt"
		elif [ "$brackets"==3 ]; then sed -i "s/{[^}]*}//g" "$sub.srt" 
		fi
		#remove single "-"
		sed -i '/-$/d' "$sub.srt"
		#remove leading spaces
		sed -i 's/^ //' "$sub.srt"
		#convert to .ass and back to remove empty time stamps in  srt file (not nessesaery but creates cleaner srt file)
		ffmpeg -i "$sub.srt" "$sub.ass"
		ffmpeg -i "$sub.ass" -y "$sub.srt"
		rm "$sub.ass"
		

	fi
# remove "-" from single lines where second line was removed
counter=0	#line counter
mark=0
while read -r line;
do
		if [[ "$line" == -* ]]; then
					if [[ "$mark" == 1 ]]; 
					then mark=0
					else mark=1
				fi
		else
				if [[ "$mark" == 1 ]]; 
					then sed -i ""$counter"s/-//" "$sub.srt"
					mark=0
				else mark=0
				fi
 		fi
	counter=$((counter+1))
done < "$sub.srt"	
done
