#!/bin/bash

# Variables
DATASET=$1
BUCKET_NAME=$2

# Download the dataset from Kaggle
kaggle datasets download -d ${DATASET}

# Get zip filename
ZIP_FILE=$(ls | grep ".zip")

# Unzip the downloaded file
unzip ${ZIP_FILE}
rm ${ZIP_FILE}
# Upload the CSV file(s) to the GCS bucket
for FILE_NAME in $(ls | grep ".csv"); do
  gsutil cp ${FILE_NAME} gs://${BUCKET_NAME}
  rm ${FILE_NAME}
  echo "File ${FILE_NAME} has been uploaded to bucket ${BUCKET_NAME} successfully."
done
