import requests

# User exists (returns 200)
response = requests.get('http://127.0.0.1:5000/api/verify',
                       headers={'X-Username': 'toms'})
print(response.status_code)  # 200
print(response.json())

# User doesn't exist (returns 404)
response = requests.get('http://127.0.0.1:5000/api/verify',
                       headers={'X-Username': 'john'})
print(response.status_code)  # 404