defmodule BlockchainTest do
  use ExUnit.Case
  require Logger

  doctest Showdown


  test "should get block hash" do
    block = Game.Blockchain.get_block(1)
    assert block == "0xfc2cff3ad218159d603dfbb080d5addc49f4e100448a577178ca34c756136353"
  end

  test "should get correct card positions for flop" do
    position = Game.Blockchain.get_card_position_by_hash(:flop, 1)
    assert(position == '}vm')
  end
end
