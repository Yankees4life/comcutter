@echo off
set file=%1
REM Finding commercials
comskip --ini=comskip.ini %file%
REM Cutting out commercials
copy %file%.ts video.ts
copy %file%.ffsplit video.ffsplit
for /f "usebackq tokens=*" %%a in (`bat video.ffsplit`) do ffmpeg -i video.ts %%a
REM Merging the cuts to one file and remuxing to mp4
for /f "usebackq tokens=*" %%i in (`fd "segment*"`) do echo file %%i >> edit.txt
ffmpeg -f concat -i edit.txt -c copy edit.mp4
rename edit.mp4 %file%.mp4
REM Cleanup input files
for /f "usebackq tokens=*" %%b in (`fd "segment*"`) do del /f %%b
del /f edit.txt
del /f video.ts
del /f video.ffsplit
del /f %file%.txt
del /f %file%.log
del /f %file%.ffsplit
del /f %file%.ts
