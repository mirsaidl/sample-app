from flask import Flask, request, render_template, jsonify
import requests
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

WEATHER_API_URL = "https://api.weatherapi.com/v1/current.json"
API_KEY = os.getenv('WEATHER_API_KEY', 'da7de5db55d2ecdb6209c17c812f34f0')

@app.route("/")
def main():
    return render_template("index.html")

@app.route("/weather", methods=['POST'])
def get_weather():
    city = request.form.get('city')
    try:
        params = {
            'key': API_KEY,
            'q': city,
            'aqi': 'no'
        }
        response = requests.get(WEATHER_API_URL, params=params)
        data = response.json()
        
        if response.status_code == 200:
            weather_info = {
                'location': data['location']['name'],
                'country': data['location']['country'],
                'temperature': data['current']['temp_c'],
                'condition': data['current']['condition']['text'],
                'humidity': data['current']['humidity'],
                'wind_speed': data['current']['wind_kph']
            }
            return jsonify({'success': True, 'data': weather_info})
        else:
            return jsonify({'success': False, 'error': 'City not found'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)
