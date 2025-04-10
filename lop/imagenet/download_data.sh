#!/bin/bash

# Create data directory if it doesn't exist
mkdir -p data

# Define the Google Drive file ID and output filename
FILE_ID="1i0ok3LT5_mYmFWaN7wlkpHsitUngGJ8z"
OUTPUT_FILE="data/imagenet_data.zip"

echo "Downloading ImageNet data..."

# Using curl with Google Drive direct download method
curl -L "https://drive.google.com/uc?export=download&id=${FILE_ID}" -o "${OUTPUT_FILE}"

# Check if download was successful
if [ $? -eq 0 ] && [ -f "${OUTPUT_FILE}" ]; then
    echo "Download completed successfully. Extracting files..."
    
    # Extract the downloaded zip file
    unzip "${OUTPUT_FILE}" -d data/
    
    # Check if extraction was successful
    if [ $? -eq 0 ]; then
        echo "Extraction completed successfully."
        
        # Verify that the classes directory exists
        if [ -d "data/classes" ]; then
            echo "Data setup complete. You can now run the experiments."
        else
            echo "ERROR: 'classes' directory not found in the extracted data."
            echo "Please check the downloaded archive structure."
        fi
    else
        echo "ERROR: Failed to extract the downloaded file."
    fi
else
    echo "ERROR: Download failed."
    echo "Please try downloading manually from: https://drive.google.com/file/d/1i0ok3LT5_mYmFWaN7wlkpHsitUngGJ8z/view?usp=sharing"
    echo "After downloading, extract the file into the 'data' directory."
fi

# Make the download script executable
chmod +x download_data.sh