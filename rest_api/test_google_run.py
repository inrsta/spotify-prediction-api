"""This file is used to send a test request to the API endpoint."""
import requests

song_features = {
    "danceability": 0.5,
    "energy": 0.5,
    "loudness": 0.5,
    "speechiness": 0.5,
    "acousticness": 0.5,
    "duration_minutes": 3,
    "valence": 0.5,
    "tempo": 0.5,
    "liveness": 0.5,
    "genre": 1,
}

# Update the URL with the external IP address
URL = "https://spotify-predict-api-dbtolisexq-ew.a.run.app/predict"
print("Before sending request...")
response = requests.post(URL, json=song_features, timeout=30)
print(response.json())
