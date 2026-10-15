#!/bin/bash
set -e

APP_DIR="/home/ec2-user/student-result-predictor"
VENV_DIR="$APP_DIR/venv"

echo "Starting Student Result Predictor deployment..."

# Install Python and virtual environment support
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-venv

# Move to application directory
cd "$APP_DIR"

# Create virtual environment if it does not exist
if [ ! -f "$VENV_DIR/bin/python" ]; then
    python3 -m venv "$VENV_DIR"
fi

# Install dependencies inside virtual environment
"$VENV_DIR/bin/python" -m pip install --upgrade pip
"$VENV_DIR/bin/python" -m pip install -r requirements.txt

# Stop previous application process if running
pkill -f '[s]treamlit run app.py' || true
pkill -f '[p]ython3 app.py' || true

# Start application in background
nohup "$VENV_DIR/bin/python" app.py > app.log 2>&1 &

APP_PID=$!
sleep 5

# Verify process startup
if kill -0 "$APP_PID" 2>/dev/null; then
    echo "Application process started successfully."
else
    echo "Application failed to start:"
    tail -50 app.log || true
    exit 1
fi

echo "Deployment completed successfully."
