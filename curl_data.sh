#!/bin/bash
for symb in BTCUSD ETHUSD EOSUSD XRPUSD BCHUSD NEOUSD LTCUSD IOTUSD XMRUSD ETCUSD OMGUSD DSHUSD ZECUSD TRXUSD BTGUSD ETPUSD SANUSD BFTUSD BATUSD QTMUSD GNTUSD ZRXUSD EDOUSD REPUSD ELFUSD SPKUSD TNBUSD SNTUSD QSHUSD WAXUSD FUNUSD DAIUSD YYWUSD DATUSD MNAUSD LRCUSD AVTUSD IOSUSD MTNUSD AIDUSD NECUSD RDNUSD AGIUSD RCNUSD SNGUSD RLCUSD RRTUSD AIOUSD CFIUSD ODEUSD REQUSD
do
	stamp=1364773500000 # starting timestamp supporting 15m
	i=0
	touch historical_data_$symb.mat
	while [ $i -lt 177 ]; do
		curl "https://api.bitfinex.com/v2/candles/trade:15m:t$symb/hist?limit=1000&start=$stamp&end=$(expr $stamp + 899999999)&sort=1" -o tempo.mat # limit cannot be set greater than 1000 and is 120 if not passed value
		if [ "$(head -c 2 tempo.mat)" == "[[" ]; then
			cat tempo.mat >> historical_data_$symb.mat
			let "stamp += 900000000" # = 15 (m) * 60 (s) * 1000 (ms) * 1000 (limit)
			let "i++"
		elif [ "$(head -c 2 tempo.mat)" == "[]" ]; then
			let "stamp += 900000000"
			let "i++"
		else
			echo "PROBLEM OCCURRED at $stamp - $(expr $stamp + 899999999): $(<tempo.mat) - sleeping for one minute"
			sleep 65
		fi
	done
	rm tempo.mat
	sed -i 's/\]\]\[\[/\],\[/g' historical_data_$symb.mat
done
