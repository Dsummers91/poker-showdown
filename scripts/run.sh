#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && cd ../ > /dev/null && pwd )"

pushd $DIR
iex -S mix phx.server
popd
