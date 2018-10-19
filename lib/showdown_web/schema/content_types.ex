defmodule ShowdownWeb.Schema.Accounts do
    use Absinthe.Schema.Notation

    object :user do
          field :id, :id
          field :address, :string
        end
end

defmodule ShowdownWeb.Schema.Games do
  use Absinthe.Schema.Notation
  import_types Absinthe.Type.Custom

  object :game do
    field :id, :id
    field :players, :integer
    field :round, :string
    field :starting_block, :integer
    field :board_hash, :string
    field :board, :integer
    field :inserted_at, :naive_datetime
  end
end
