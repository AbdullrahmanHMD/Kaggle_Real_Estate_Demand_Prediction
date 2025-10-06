#!/bin/bash

echo "Workingdir: $PWD";
echo "Started at $(date)";

# Check if conda is available
if ! command -v conda &> /dev/null; then

    OS_TYPE=$(uname)

    if [ "$OS_TYPE" == "Linux" ]; then
      echo "Conda is not found. Installing Miniconda..."

      wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  -O /tmp/miniconda.sh

      bash /tmp/miniconda.sh -b -p "$HOME/miniconda3"

      rm /tmp/miniconda.sh

    else
      echo "Conda is not found. Please install Anaconda or Miniconda"
      exit 1

    fi
fi

eval "$(conda shell.bash hook)"

conda update -y -n base -c defaults conda

ENV_NAME="kaggle_env"

if ! conda info --envs | grep -q "$ENV_NAME"; then
    echo "Creating conda environment '$ENV_NAME'..."
    conda create -y --name "$ENV_NAME" python=3.12
else
    echo "Conda environment '$ENV_NAME' already exists."
fi

conda activate "$ENV_NAME"

if [ -f "requirements.txt" ]; then
    echo "Installing dependencies from requirements.txt..."
    pip install --no-cache-dir -r requirements.txt
else
    echo "No requirements.txt found. Skipping dependency installation."
fi

echo "Setup Complete at $(date)"
