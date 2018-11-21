defmodule Showdown.Casino do
  import Ecto.Query, only: [from: 2]

  @moduledoc """
  The Casino context.
  """

  import Ecto.Query, warn: false
  alias Showdown.Repo
  alias Showdown.Accounts.User
  alias Showdown.Card
  alias Showdown.Owner

  def get_owner(player_name) do
    Repo.get_by(Showdown.Owner, %{name: player_name})
  end

  #### CARDS ####
  def list_cards do
    Repo.all(Card)
  end

  def get_card!(id), do: Repo.get!(Card, id)

  def get_card(%Game.Cards{suit: suit, number: number}) do
    Repo.get_by(Card, %{suit: to_string(suit), number: number})
  end

  def create_card(attrs) do
    %Card{}
    |> Card.changeset(attrs)
    |> Repo.insert()
  end

  def delete_card(%Card{} = card) do
    Repo.delete(card)
  end

  def change_card(%Card{} = card) do
    Card.changeset(card, %{})
  end

  ##### GAMES ####
  def assign_cards_to_game(game) do
    {:error, "error assigning cards"}
  end

  def assign_player_cards_to_game(game2, game) do
    game = Map.put_new(game, :players, [])
    Enum.with_index(game.players, 1)
      |> Enum.map(fn {player,i} ->
      if length(player) > 1 do
        player
          |> Enum.map(fn card -> assign_cards(game2, card, "player"<>to_string(i)) end)
      end
    end)
    game
  end
 
  def assign_cards(game_id, card, owner) when is_number(game_id) do
    %Showdown.GameCards{}
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:card, get_card(card))
      |> Ecto.Changeset.put_assoc(:game, get_game(game_id))
      |> Ecto.Changeset.put_assoc(:owner,get_owner(owner)) 
      |> Repo.insert!
  end

  def assign_cards(game, card, owner) do
    {:ok, game} = game
    %Showdown.GameCards{}
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:card, get_card(card))
      |> Ecto.Changeset.put_assoc(:game, get_game(game.id))
      |> Ecto.Changeset.put_assoc(:owner,get_owner(owner)) 
      |> Repo.insert!
  end

  def update_game(%Showdown.Game{id: id}, game) do
    game
     |> Map.take([:round])
     |> (&(Showdown.Game.changeset(Repo.get(Showdown.Game, id) |> Repo.preload([cards: [:card, :owner]]), &1))).()
     |> Repo.update
  end

  def create_game(game) do
    result = game
      |> Map.take([:starting_block, :deck_hash, :board])
      |> Map.put_new(:round, "preflop")
      |> (&(Showdown.Game.changeset(%Showdown.Game{}, &1))).()
      |> Repo.insert

    result
      |> assign_player_cards_to_game(game)

    result
  end

  def list_games() do
    Repo.all(Showdown.Game)
      |> Repo.preload([cards: [:card, :owner]])
  end

  def list_owners() do
    Repo.all(Owner)
  end

  def get_game(id) do
    Repo.get(Showdown.Game, id) |> Repo.preload([:winner])
  end

  def get_game!(id) do
    Repo.get!(Showdown.Game, id)
  end

  def find_game(id) do
    Repo.get(Showdown.Game, id)
      |> Repo.preload([winner: [:winner], cards: [:card, :owner]])
  end

  def list_active_games() do
    Repo.all(from game in Showdown.Game, where: game.round in ["preflop", "flop", "turn"])
      |> Repo.preload([cards: [:card, :owner]])
  end

  def change_game(%Showdown.Game{} = game) do
    Showdown.Game.changeset(game, %{})
  end
  

  ### GAME BETS
  def total_bets(game_id) do
    query = from gb in Showdown.Casino.GameBets, 
              where: gb.game_id == ^game_id, 
              join: p in Showdown.Owner, on: gb.player_id == p.id,
              group_by: p.name,
              select: {p.name, sum(gb.bet_amount)}

    players_bets = Repo.all(query)
      |> Enum.into([])

    total = Enum.reduce(players_bets, 0, fn x, acc -> elem(x, 1) + acc end)
    
    Map.put(Enum.into(players_bets, %{}), "total", total)

  end

  def get_bets_by_game_winner(game_id, player) do
    query = from gb in Showdown.Casino.GameBets,
      where: gb.game_id == ^game_id,
      join: p in Showdown.Owner, on: gb.player_id == p.id and p.name == ^player,
      join: u in Showdown.Accounts.User, on: gb.user_id == u.id,
      select: {u.address, gb.bet_amount}
    Repo.all(query)
  end

  def insert_winner(%Game.Table{id: id}, player) do
    player = case is_binary(player) do
      true -> player
      false -> to_string(player)
    end

    winner = Repo.get_by(Showdown.Owner, %{name: player})
    game = Repo.get(Showdown.Game, id)

    %Showdown.Casino.GameWinners{}
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:winner, winner)
      |> Ecto.Changeset.put_assoc(:game, game)
      |> Repo.insert!
  end

  def add_bet(%Showdown.Game{round: "preflop"} = game, player_name, user_address, bet_amount) do
    player = Repo.get_by(Showdown.Owner, %{name: player_name})
    user = Repo.get_by(Showdown.Accounts.User, %{address: user_address})
    with {:ok, _} <- decrease_balance(user, bet_amount) do
        %Showdown.Casino.GameBets{}
          |> Ecto.Changeset.change()
          |> Ecto.Changeset.put_assoc(:player, player)
          |> Ecto.Changeset.put_assoc(:user, user)
          |> Ecto.Changeset.put_assoc(:game, game)
          |> Ecto.Changeset.put_change(:bet_amount, bet_amount)
          |> Repo.insert
    else
      err -> err
    end
  end

  def add_bet(game, player_name, user_address, bet_amount) do
    {:error, "Only able to bet during preflop phase"} 
  end
  
  def increase_balance(address, amount) when is_binary(address) do
    increase_balance(%Showdown.Accounts.User{address: address}, amount)
  end

  @spec increase_balance(Showdown.Accounts.User, integer) :: {atom, Showdown.Accounts.User}
   def increase_balance(%Showdown.Accounts.User{address: address}, amount) do
    player = from(u in User, where: u.address == ^address)
      |> Repo.one()

    if player do
      player
        |> User.changeset(%{balance: player.balance + amount})
        |> Repo.update
    else
      {:error, "player does not exist"}
    end
  end 
  
  def decrease_balance(nil, amount) do
    {:error, "user does not exist"}
  end

  @spec decrease_balance(Showdown.Accounts.User, integer) :: {atom, Showdown.Accounts.User}
  def decrease_balance(%Showdown.Accounts.User{id: id, balance: balance}, amount) do
    player = from(u in User, where: u.id == ^id, lock: "FOR UPDATE")
      |> Repo.one()

    if player do
      if player.balance - amount < 0 do
        {:error, "Player does not have sufficient balance"}
      else
        player
          |> User.changeset(%{balance: player.balance - amount})
          |> Repo.update
      end
    else
      {:error, "player does not exist"}
    end
  end
end
