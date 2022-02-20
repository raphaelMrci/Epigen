@echo off

set GREEN=[32m
set RED=[31m
set YELL=[33m
set BLUE=[34m
set MAGENTA=[35m
set CYAN=[36m
set WHITE=[37m
set NC=[0m

:check_permissions
    echo Administrative permissions required. Detecting permissions...

    net session >nul 2>&1
    if %errorLevel% == 0 (
        echo %GREEN%Success: Administrative permissions confirmed.%NC%
    ) else (
        echo %RED%Failure: Current permissions inadequate. Please run this script with admin rights.%NC%
        exit 84
    )
echo.
echo.
echo   .d888      8888888888 8888888b. 8888888 .d8888b.  8888888888 888b    888          888b.
echo  d88P"       888        888   Y88b  888  d88P  Y88b 888        8888b   888           "Y88b
echo  888         888        888    888  888  888    888 888        88888b  888             888
echo .888         8888888    888   d88P  888  888        8888888    888Y88b 888             888.
echo 888(         888        8888888P"   888  888  88888 888        888 Y88b888             )888
echo "888         888        888         888  888    888 888        888  Y88888             888"
echo  888         888        888         888  Y88b  d88P 888        888   Y8888 d8b         888
echo  Y88b.       8888888888 888       8888888 "Y8888P88 8888888888 888    Y888 Y8P       .d88P
echo   "Y888                                                                             888P"
echo.
echo Developed by Raphael MERCIE - EPITECH Toulouse 2026
echo.
echo ------------ Starting installation ------------
