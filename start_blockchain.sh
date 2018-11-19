#!/bin/bash
kill `lsof -t -i:8545` >/dev/null 2>&1

rm ./blockchain/working -rf
cp ./blockchain/pristine ./blockchain/working -r

ganache-cli -b 3 --db ./blockchain/working -s "showdown-poker" &>/dev/null &2>&1 &
mix ecto.reset
