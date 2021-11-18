@echo off
REM Finding commercials
comskip --ini=comskip.ini %1
REM Cutting out commercials
copy %1 video.ts
copy "%~dpn1.ffsplit" "video.ffsplit"
for /f "usebackq tokens=*" %%a in (`bat video.ffsplit`) do ffmpeg -i video.ts %%a
REM Merging the cuts to one file and remuxing to mp4
for /f "usebackq tokens=*" %%i in (`fd "segment*"`) do echo file %%i >> edit.txt
ffmpeg -f concat -i edit.txt -c copy edit.ts
move /y edit.ts %1
REM Cleanup input files
for /f "usebackq tokens=*" %%b in (`fd "segment*"`) do del /f %%b
del /f edit.txt
del /f video.ts
del /f video.ffsplit
del /f "%~dpn1.txt"
del /f "%~dpn1.log"
del /f "%~dpn1.ffsplit"
del /f "%~dpn1.edl"
