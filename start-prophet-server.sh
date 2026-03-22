#!/bin/bash

# Prophet Model Server Startup Script for Linux/macOS
# This script starts the FastAPI server on port 8000
#
# Prerequisites:
#   - Python 3.8+ installed
#   - Virtual environment at model/.venv
#   - Dependencies installed via: pip install -r model/requirements.txt

echo ""
echo "========== Prophet Model Server =========="
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$SCRIPT_DIR"
MODEL_DIR="$PROJECT_ROOT/model"

echo "Project Root: $PROJECT_ROOT"
echo "Model Directory: $MODEL_DIR"
echo ""

cd "$PROJECT_ROOT"

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python 3 is not installed"
    exit 1
fi

# Check if virtual environment exists
if [ ! -d "$MODEL_DIR/.venv" ]; then
    echo "[INFO] Virtual environment not found at $MODEL_DIR/.venv"
    echo "[INFO] Creating virtual environment..."
    cd "$MODEL_DIR"
    python3 -m venv .venv
    if [ $? -ne 0 ]; then
        echo "[ERROR] Failed to create virtual environment"
        exit 1
    fi
    echo "[OK] Virtual environment created"
fi

# Activate virtual environment
echo ""
echo "[INFO] Activating virtual environment..."
source "$MODEL_DIR/.venv/bin/activate"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to activate virtual environment"
    exit 1
fi

# Install dependencies
echo "[INFO] Installing/checking dependencies..."
cd "$MODEL_DIR"
pip install -q -r requirements.txt
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to install dependencies"
    echo "[INFO] Try running: pip install -r model/requirements.txt"
    exit 1
fi

# Start the server
echo ""
echo "========== Starting FastAPI Server =========="
echo "[INFO] Server will run on http://localhost:8000"
echo "[INFO] Interactive docs: http://localhost:8000/docs"
echo "[INFO] Press Ctrl+C to stop"
echo ""

cd "$MODEL_DIR"
uvicorn server.main:app --reload --port 8000

# Deactivate virtual environment
deactivate

