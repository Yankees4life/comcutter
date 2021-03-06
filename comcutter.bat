@echo off
REM Finding commercials
comskip --ini=comskip.ini %1
REM Cutting out commercials
copy %1 "%~dp1\video.ts"
copy "%~dpn1.ffsplit" "%~dp1\video.ffsplit"
cd %~dp1
for /f "usebackq tokens=*" %%a in (`bat video.ffsplit`) do ffmpeg -i video.ts %%a
REM Merging the cuts to one file and remuxing to mp4
for /f "usebackq tokens=*" %%i in (`dir /b segment*.ts`) do echo file %%i >> edit.txt
ffmpeg -f concat -i edit.txt -c copy edit.mp4
rename edit.mp4 "%~dpn1.mp4"
REM Cleanup input files
for /f "usebackq tokens=*" %%b in (`dir /b segment*.ts`) do del /f %%b
del /f edit.txt
del /f video.ts
del /f video.ffsplit
del /f "%~dpn1.txt"
del /f "%~dpn1.log"
del /f "%~dpn1.ffsplit"
del /f "%~dpn1.edl"
REM You can delete the original file if you like
REM del /f %1
