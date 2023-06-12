# cc2sub

cc2sub is a small bash script that extracts the close captions of all video files in a folder and removes the close caption parts in brackets turning them into subtitles

# Requirements
dos2linux 
ffmpeg

# Usage

The script extracts one subtitles from every video file in the execution directory and removes the closed caption comments in [], () or {}
it creates an srt file next to the video file, it does not mux the subtitle into the video file. Set the type and the desired close caption stream in the script.
