@echo off
echo ==========================================
echo    RentGo - Starting Flutter App
echo ==========================================
echo.

cd Mobile-Project-main

echo [1/2] Installing Flutter dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo.
    echo Error: Failed to get Flutter dependencies!
    echo Please make sure Flutter is installed and in PATH.
    pause
    exit /b 1
)

echo.
echo [2/2] Starting Flutter Application...
echo.
echo ==========================================
echo    Make sure:
echo    1. Android Emulator is running
echo    2. Backend server is running
echo ==========================================
echo.

call flutter run

pause

