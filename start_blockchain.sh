#!/bin/bash
rm ./blockchain/working -rf
cp ./blockchain/pristine ./blockchain/working -r
ganache-cli -b 3 --db ./blockchain/working  &>/dev/null &2>&1 &
