@echo off
echo ==========================================
echo    RentGo - Starting Backend Server
echo ==========================================
echo.

cd backend

echo [1/3] Installing Node.js dependencies...
call npm install
if %errorlevel% neq 0 (
    echo.
    echo Error: Failed to install dependencies!
    echo Please make sure Node.js is installed.
    pause
    exit /b 1
)

echo.
echo [2/3] Initializing Database...
call npm run init-db
if %errorlevel% neq 0 (
    echo.
    echo Error: Failed to initialize database!
    echo Please make sure MySQL is running.
    pause
    exit /b 1
)

echo.
echo [3/3] Starting Backend Server...
echo.
echo ==========================================
echo    Server is running on Port 3000
echo    URL: http://localhost:3000
echo ==========================================
echo.
echo Press Ctrl+C to stop the server
echo.

call npm start

pause

