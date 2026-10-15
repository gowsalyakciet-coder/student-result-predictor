#!/bin/bash
set -e

APP_DIR="/home/ec2-user/student-result-predictor"

echo "Starting Student Result Predictor deployment..."

# Install Python using the available package manager
if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y python3 python3-pip
elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y python3 python3-pip
else
    echo "ERROR: No supported package manager found."
    exit 1
fi

# Navigate to the deployed application
cd "$APP_DIR"

# Install Python dependencies
python3 -m pip install -r requirements.txt

# Stop the previous application process if running
pkill -f '[s]treamlit run app.py' || true
pkill -f '[p]ython3 app.py' || true

# Start the application
nohup python3 app.py > app.log 2>&1 &

sleep 3

# Check whether the application is still running
if kill -0 "$!" 2>/dev/null; then
    echo "Application process started successfully."
else
    echo "ERROR: Application failed to start."
    tail -50 app.log || true
    exit 1
fi

echo "Deployment completed successfully."
