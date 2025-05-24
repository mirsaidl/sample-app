from flask import Flask, request, render_template, jsonify
import requests

app = Flask(__name__)

FACTS_API_URL = "https://uselessfacts.jsph.pl/api/v2/facts/random"

@app.route("/")
def main():
    return render_template("index.html")

@app.route("/fact", methods=['POST'])
def get_fact():
    try:
        # Get a random fact in English
        params = {
            'language': 'en'
        }
        response = requests.get(FACTS_API_URL, params=params)
        data = response.json()
        
        if response.status_code == 200:
            fact_info = {
                'text': data['text'],
                'source': data['source'],
                'source_url': data['source_url']
            }
            return jsonify({'success': True, 'data': fact_info})
        else:
            return jsonify({'success': False, 'error': 'Failed to fetch fact'})
    except Exception as e:
        return jsonify({'success': False, 'error': str(e)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5050)
