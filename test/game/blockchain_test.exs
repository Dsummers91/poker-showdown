defmodule BlockchainTest do
  use ExUnit.Case
  require Logger

  doctest Showdown


  test "should get block hash" do
    block = Game.Blockchain.get_block(1)
    assert block == "0xa1cba46937d316c5d50e36b376fd8da5e0b542ce8f15a82e5c13d6cfe58e9650"
  end

  test "should get correct card positions for flop" do
    position = Game.Blockchain.get_card_position_by_hash(:flop, 1)
    assert(position == [97, 92, 141])
  end
end
