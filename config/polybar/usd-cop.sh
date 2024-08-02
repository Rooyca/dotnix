#!/bin/sh

API="https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies"

# check if there is an internet connection
curl -s google.com > /dev/null
if [ $? -ne 0 ]; then
    echo "󰅚"
    exit 1
fi

quote=$(curl -sf $API'/usd/cop.json' | jq -r ".cop")
quote=$(LANG=C printf "%.f" "$quote")

echo "$quote"