#!/bin/bash
set -e

# Navigate to the deployed application directory
cd /home/ec2-user/student-result-predictor

echo "Starting Student Result Predictor deployment..."

# Install Python and pip if needed (Amazon Linux 2023)
sudo dnf install -y python3 python3-pip

# Install application dependencies
python3 -m pip install -r requirements.txt --quiet

# Stop any previously running instance of the app
pkill -f "[s]treamlit run app.py" || true
pkill -f "[p]ython3 app.py" || true

# Start the application in the background
nohup python3 app.py > app.log 2>&1 &

echo "Deployment completed."
