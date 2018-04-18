#!/bin/bash
stamp=1364773500000 # starting timestamp supporting 15m
touch historical_data.mat
for i in {1..18}; do
	curl "https://api.bitfinex.com/v2/candles/trade:15m:tBTCUSD/hist?limit=1000&start=$stamp&end=$(expr $stamp + 899999999)&sort=1" -o temp.mat # limit cannot be set greater than 1000 and is 120 if not passed value
	if [ "$(head -c 2 temp.mat)" == "[[" ]; then
		cat temp.mat >> historical_data.mat
		let "stamp += 900000000" # = 15 (m) * 60 (s) * 1000 (ms) * 1000 (limit)
	else
		echo "PROBLEM OCCURRED at $stamp - $(expr $stamp + 899999999): $(<temp.mat) - sleeping for one minute"
		let "i--"
		sleep 60
	fi
done
rm temp.mat
sed -i '' 's/\]\]\[\[/\],\[/g' historical_data.mat
