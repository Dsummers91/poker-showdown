# Showdown Poker
README in progress

## Installation
```
mix ecto.create
mix ecto.migrate
npm i -g ganache-cli
mix deps.get
```

## Running
```
./start_blockchain.sh
iex -S mix phx.server
```

Zhen use this to run
```
./start_blockhain.sh
MIX_ENV=zhen iex -S mix phx.server
```

GUI API - http://localhost:4000/api/graphiql
or
http://localhost:4000/api



## Miscellaneous

Get current block from blockchain
`web3.eth.getBlock('latest', (err ,res) => {console.log(res)})`

## RULES
  - Game Started Every _ minute interval, Current Block on Network is Stored
  - A specific block in the future is chosen to select flop/turn/river




### Shuffling System
Shuffling system is secure, as to the reward is less than the block reward
