"""Flask app to build the API endpoint."""
import os
import pickle

import mlflow
import pandas as pd
from flask import Flask, jsonify, request
from google.cloud import storage
from sklearn.feature_extraction import DictVectorizer

RUN_ID = os.getenv("RUN_ID")
BUCKET_NAME = os.getenv("BUCKET_NAME")


def download_blob(
    bucket: str, source_blob_name: str, destination_file_name: str
) -> None:
    """
    Downloads a blob from the specified GCP bucket and saves it in the script's
    directory.

    Args:
        bucket (str): Name of the GCP bucket where the blob is stored.
        source_blob_name (str): The name of the blob (object) in the GCP bucket.
        destination_file_name (str): Desired file name for the downloaded blob in the
        script's directory.

    Returns:
        None: Prints out a message confirming the blob download.
    """

    storage_client = storage.Client()
    bucket = storage_client.bucket(bucket)
    blob = bucket.blob(source_blob_name)

    # Get the directory of the current script
    script_directory = os.path.dirname(os.path.abspath(__file__))

    # Join the script directory with the destination file name to get the full path
    full_destination_path = os.path.join(script_directory, destination_file_name)

    blob.download_to_filename(full_destination_path)

    print(f"Blob {source_blob_name} downloaded to {full_destination_path}.")


bucket_name = f"{BUCKET_NAME}"
source_blob_name = f"777690043149883111/{RUN_ID}/artifacts/preprocessor/preprocessor.b"
DESTINATION_FILE_NAME = "preprocessor.b"  # for example, 'myfile.txt'

download_blob(bucket_name, source_blob_name, DESTINATION_FILE_NAME)


logged_model = f"gs://{BUCKET_NAME}/777690043149883111/{RUN_ID}/artifacts/models_mlflow"
model = mlflow.pyfunc.load_model(logged_model)

with open(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "preprocessor.b"), "rb"
) as f_in:
    dv = pickle.load(f_in)


app = Flask("spotify-prediction")


@app.route("/predict", methods=["POST"])
def predict_endpoint():
    song_features = request.get_json()

    print("Just received the features from the request...")

    # Convert song features to DataFrame
    df = pd.DataFrame([song_features])

    song_dict = df.to_dict(orient="records")
    transformed_data = dv.transform(song_dict)
    prediction = model.predict(transformed_data)

    print("Just finished the prediction...")

    result = {
        "prediction": float(prediction[0]),
    }

    return jsonify(result)


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=9696)
