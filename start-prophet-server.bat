@echo off
REM Prophet Model Server Startup Script for Windows
REM This script starts the FastAPI server on port 8000
REM
REM Prerequisites:
REM   - Python 3.8+ installed
REM   - Virtual environment at model/.venv
REM   - Dependencies installed via: pip install -r model/requirements.txt

setlocal enabledelayedexpansion

echo.
echo ========== Prophet Model Server ==========
echo.

REM Get the project root directory
for /d %%A in ("%~dp0") do set "PROJECT_ROOT=%%~dpA"
set "MODEL_DIR=%PROJECT_ROOT%model"

echo Project Root: %PROJECT_ROOT%
echo Model Directory: %MODEL_DIR%
echo.

REM Check if virtual environment exists
if not exist "%MODEL_DIR%\.venv" (
    echo [ERROR] Virtual environment not found at %MODEL_DIR%\.venv
    echo [INFO] Creating virtual environment...
    cd /d "%MODEL_DIR%"
    python -m venv .venv
    if errorlevel 1 (
        echo [ERROR] Failed to create virtual environment
        exit /b 1
    )
    echo [OK] Virtual environment created
)

REM Activate virtual environment and install dependencies
echo.
echo [INFO] Activating virtual environment...
call "%MODEL_DIR%\.venv\Scripts\activate.bat"
if errorlevel 1 (
    echo [ERROR] Failed to activate virtual environment
    exit /b 1
)

echo [INFO] Installing/checking dependencies...
cd /d "%MODEL_DIR%"
pip install -q -r requirements.txt
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies
    echo [INFO] Try running: pip install -r model/requirements.txt
    exit /b 1
)

REM Start the server
echo.
echo ========== Starting FastAPI Server ==========
echo [INFO] Server will run on http://localhost:8000
echo [INFO] Interactive docs: http://localhost:8000/docs
echo [INFO] Press Ctrl+C to stop
echo.

cd /d "%MODEL_DIR%"
uvicorn server.main:app --reload --port 8000

REM Deactivate virtual environment
call "%MODEL_DIR%\.venv\Scripts\deactivate.bat"

pause
