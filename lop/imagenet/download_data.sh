#!/bin/bash

# Create data directory if it doesn't exist
mkdir -p data

# Define the Google Drive file ID and output filename
FILE_ID="1i0ok3LT5_mYmFWaN7wlkpHsitUngGJ8z"
OUTPUT_FILE="data/imagenet_data.zip"

echo "Downloading ImageNet data..."

# Check if gdown is installed, if not, try to install it
if ! command -v gdown > /dev/null; then
    echo "gdown not found, attempting to install..."
    pip install gdown
fi

# Download using gdown
gdown --id ${FILE_ID} -O ${OUTPUT_FILE}

# Check if download was successful
if [ -f "${OUTPUT_FILE}" ]; then
    # Get file size
    FILE_SIZE=$(stat -c%s "${OUTPUT_FILE}")
    
    # Check if file size is too small (likely an error HTML page)
    if [ "$FILE_SIZE" -lt 10000 ]; then
        echo "ERROR: Downloaded file is too small (${FILE_SIZE} bytes). Likely not the correct file."
        echo "Please try downloading manually from: https://drive.google.com/file/d/${FILE_ID}/view?usp=sharing"
        echo "After downloading, extract the file into the 'data' directory."
        exit 1
    fi
    
    echo "Download completed successfully. Extracting files..."
    
    # Extract the downloaded zip file
    unzip -o "${OUTPUT_FILE}" -d data/
    
    # Check if extraction was successful
    if [ $? -eq 0 ]; then
        echo "Extraction completed successfully."
        
        # Verify that the classes directory exists
        if [ -d "data/classes" ]; then
            echo "Data setup complete. You can now run the experiments."
        else
            echo "WARNING: 'classes' directory not found in the extracted data."
            echo "Please check the extracted files structure."
            ls -la data/
        fi
    else
        echo "ERROR: Failed to extract the downloaded file."
        echo "The file may be corrupted or not a valid zip archive."
    fi
else
    echo "ERROR: Download failed. File not found."
    echo "Please try downloading manually from: https://drive.google.com/file/d/${FILE_ID}/view?usp=sharing"
    echo "After downloading, extract the file into the 'data' directory."
fi