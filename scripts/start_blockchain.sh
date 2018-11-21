#!/bin/bash
kill `lsof -t -i:8545` >/dev/null 2>&1

rm ./blockchain/working -rf
cp ./blockchain/pristine ./blockchain/working -r

echo "Initializing blockchain"
ganache-cli -b 3 --db ./blockchain/working -s "showdown-poker" &>/dev/null &2>&1 &
echo "Initializing local database"
mix ecto.reset >/dev/null 2>&1
echo "Done"
