defmodule Bank.Events.MoneyDeposited do
  use Ecto.Schema

  @primary_key false
  embedded_schema do
    field(:aggregate_id, :string)
    field(:amount, :integer)
    field(:version, :integer)
  end
end
