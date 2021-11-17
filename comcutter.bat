@echo off
set file=%1
REM Finding commercials
comskip --ini=comskip.ini %file%
REM Cutting out commercials
for /f "usebackq tokens=*" %a in (`bat %file%.ffsplit`) do ffmpeg -i %file%.ts %a
REM Merging the cuts to one file and remuxing to mp4
for /f "usebackq tokens=*" %i in (`fd "segment*"`) do echo file %i >> edit.txt
ffmpeg -f concat -i edit.txt -c copy edit.mp4
rename edit.mp4 %file%.mp4
REM Cleanup input files
for /f "usebackq tokens=*" %b in (`fd "segment*"`) do del /f %b
del /f edit.txt
del /f %file%.txt
del /f %file%.log
del /f %file%.ffsplit
del /f %file%.ts