defmodule BlockchainTest do
  use ExUnit.Case
  require Logger

  doctest Showdown


  test "should get block hash" do
    block = Game.Blockchain.get_block(10000)
    assert(block == "0x11236ea241f3876c2554b55833843562fb0b50476f7b5cf3416139b03f0b1884")
  end

  test "should get correct card positions for flop" do
    position = Game.Blockchain.get_card_position_by_hash(:flop, 10001)
    assert(position == [120, 101, 119])
  end
end
