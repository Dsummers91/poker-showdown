#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && cd ../ > /dev/null && pwd )"

pushd $DIR

#watches for changes in ./lib or ./test and reruns tests
while inotifywait -e close_write ./lib/ -r -e close_write ./test/ -r; do mix test; done

popd
