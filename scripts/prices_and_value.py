#!/usr/bin/env python3

import requests
import json

crypto = ["solana", "bitcoin", "cardano"]
url = "https://api.coincap.io/v2/assets"
url_usd = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/usd.min.json"

def fetch_data(url):
    response = requests.get(url)
    response.raise_for_status()  # Raise an error for bad status codes
    return json.loads(response.text)

def get_asset_price(asset):
    data = fetch_data(f"{url}/{asset}")
    return float(data["data"]["priceUsd"])

def get_cop_price():
    data = fetch_data(url_usd)
    return float(data["usd"]["cop"])

# Fetch prices for all cryptocurrencies in one go
prices = {asset: round(get_asset_price(asset), 2) for asset in crypto}

# Fetch COP price and calculate total in COP
cop_price = round(get_cop_price(), 2)

# Print the results
print(f" ${prices['solana']}  ${prices['bitcoin']} 󱗿 ${prices['cardano']} || {cop_price}")