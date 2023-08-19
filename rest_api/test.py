"""This file is used to send a test request to the API endpoint."""
import requests

song_features = {
    "danceability": 0.3,
    "energy": 0.6,
    "loudness": 0.2,
    "speechiness": 0.5,
    "acousticness": 0.7,
    "duration_minutes": 3.6,
    "valence": 0.9,
    "tempo": 0.4,
    "liveness": 0.85,
    "genre": 1,
}

URL = "http://localhost:9696/predict"
response = requests.post(URL, json=song_features, timeout=30)
print(response.json())
