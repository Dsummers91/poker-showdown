#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && cd ../ > /dev/null && pwd )"

pushd $DIR

mix absinthe.schema.json --schema ShowdownWeb.Schema ./schema.json
graphdoc -s ./schema.json -o ./docs/ -f

popd

exit 1
