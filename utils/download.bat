@echo off
setlocal

set MAP_TEST_URL=https://bit.ly/viper_test_map
set MAP_TRAIN_URL=https://bit.ly/viper_train_map
set MODEL_URL=https://www.dropbox.com/scl/fi/fg3vody0t1mhdkan6o7e4/model.zip?rlkey=bkayp9q26zkkkfg7ttxeblg9d&st=jnt8gjwu&dl=1
set MAP_TEST=maps_test.zip
set MAP_TRAIN=maps_train.zip
set MODEL=model.zip

echo Checking for download tools...

:: Check for curl (modern Windows often has it)
where curl >nul 2>nul
if %errorlevel% equ 0 (
    set DOWNLOAD_CMD=curl -L -o
    goto :download
)

:: Check for wget
where wget >nul 2>nul
if %errorlevel% equ 0 (
    set DOWNLOAD_CMD=wget -O
    goto :download
)

:: Use PowerShell as fallback
set DOWNLOAD_CMD=powershell -Command "Invoke-WebRequest -Uri
set DOWNLOAD_SUFFIX=-OutFile

:download
echo Downloading maps_test.zip
if "%DOWNLOAD_SUFFIX%"=="" (
    %DOWNLOAD_CMD% "%MAP_TEST%" "%MAP_TEST_URL%"
) else (
    %DOWNLOAD_CMD% "%MAP_TEST_URL%" %DOWNLOAD_SUFFIX% "%MAP_TEST%"
)

echo Downloading maps_train.zip
if "%DOWNLOAD_SUFFIX%"=="" (
    %DOWNLOAD_CMD% "%MAP_TRAIN%" "%MAP_TRAIN_URL%"
) else (
    %DOWNLOAD_CMD% "%MAP_TRAIN_URL%" %DOWNLOAD_SUFFIX% "%MAP_TRAIN%"
)

echo Downloading ViPER model
if "%DOWNLOAD_SUFFIX%"=="" (
    %DOWNLOAD_CMD% "%MODEL%" "%MODEL_URL%"
) else (
    %DOWNLOAD_CMD% "%MODEL_URL%" %DOWNLOAD_SUFFIX% "%MODEL%"
)

:: Extract files
echo Extracting files...
where tar >nul 2>nul
if %errorlevel% equ 0 (
    tar -xf "%MAP_TEST%"
    tar -xf "%MAP_TRAIN%"
    tar -xf "%MODEL%"
) else (
    powershell -Command "Expand-Archive -Path '%MAP_TEST%' -DestinationPath '.' -Force"
    powershell -Command "Expand-Archive -Path '%MAP_TRAIN%' -DestinationPath '.' -Force"
    powershell -Command "Expand-Archive -Path '%MODEL%' -DestinationPath '.' -Force"
)

:: Clean up
del "%MAP_TEST%" "%MAP_TRAIN%" "%MODEL%" 2>nul
echo Extraction complete!
echo.
pause