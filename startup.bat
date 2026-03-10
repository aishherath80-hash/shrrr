@echo off
REM ========================================
REM Disease Detection System - Startup Script
REM ========================================
REM Run all components: Backend API, Video Monitor, and Frontend

setlocal enabledelayedexpansion

set BACKEND_PORT=8001
set FRONTEND_PORT=5173
set VIDEO_SOURCE=http://192.168.8.128:8080/video
set POND_ID=pond-01

echo.
echo ========================================
echo Disease Detection System - Startup
echo ========================================
echo.
echo Requirements:
echo   - Backend API will run on http://localhost:%BACKEND_PORT%
echo   - Frontend will run on http://localhost:%FRONTEND_PORT%
echo   - Video monitoring from: %VIDEO_SOURCE%
echo   - Pond ID: %POND_ID%
echo.
echo Press any key to start, or Ctrl+C to cancel...
echo.
pause

REM Check if Node.js is installed (for frontend)
node --version >nul 2>&1
if errorlevel 1 (
    echo [WARNING] Node.js not found. Frontend will not start.
    echo Install from: https://nodejs.org/
)

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python not found. Cannot start backend.
    echo Install from: https://www.python.org/
    pause
    exit /b 1
)

echo.
echo Starting Backend API...
echo.
start cmd /k "title Backend API - http://localhost:%BACKEND_PORT% && cd disease-detection && python main.py"
timeout /t 3

echo.
echo Starting Video Monitor...
echo.
start cmd /k "title Video Monitor - %POND_ID% && cd disease-detection && python live_video_monitor_enhanced.py --source %VIDEO_SOURCE% --pond %POND_ID% --risk-prediction"
timeout /t 3

REM Only start frontend if Node installed
node --version >nul 2>&1
if not errorlevel 1 (
    echo.
    echo Starting Frontend...
    echo.
    start cmd /k "title Frontend - http://localhost:%FRONTEND_PORT% && cd Frontend && npm run dev"
) else (
    echo [SKIPPED] Frontend (Node.js not installed)
)

echo.
echo ========================================
echo All components started!
echo ========================================
echo.
echo Access points:
echo   Backend API:   http://localhost:%BACKEND_PORT%
echo   Frontend:      http://localhost:%FRONTEND_PORT%
echo   Test API:      http://localhost:%BACKEND_PORT%/health
echo.
echo Logs are shown in separate windows above.
echo Close windows to stop components.
echo.
pause
