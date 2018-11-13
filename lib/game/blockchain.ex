defmodule Game.Blockchain do
  require Logger
  alias Game.Deck
  alias Game.Dealer


  @spec get_card_position_by_hash(:flop | :turn | :river, Integer) :: Integer
  @dev  "64 characters so [21,22,21]"
  def get_card_position_by_hash(:flop, block_number) do
    get_block(block_number)
      |> seperate_flop_hashes
      |> Enum.map(fn i -> elem(Integer.parse(i, 16), 0) end)
      |> Enum.map(fn x -> Enum.sum(Integer.digits(x)) end) 
  end

  def get_card_position_by_hash(round, block_number) do
    sum = get_block(block_number)
      |> String.slice(2..-1)
      |> Integer.parse(16)
      |> elem(0)
      |> Integer.digits(16)
      |> Enum.sum
      [sum]
  end
  
  defp seperate_flop_hashes(hash) do
    [String.slice(hash, 2..22), String.slice(hash, 23..43), String.slice(hash, 44..-1)]
  end

  def get_block(block) do
    get_block(block, :hash)
  end

  def get_block(block, :hash) do
    "0x"<>List.to_string(Integer.to_charlist(block, 16))
      |> ExW3.block
      |> IO.inspect
      |> Map.get("hash")
  end

  def get_block(block, :number) do
    List.to_string(Integer.to_charlist(block, 16))
      |> ExW3.block
      |> Map.get("hash")
      |> Integer.parse(16)
      |> elem(0)
  end
end
