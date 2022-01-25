defmodule Bank.Commands.DepositMoney do
  @behaviour Incident.Command

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:aggregate_id, :string)
    field(:amount, :integer)
  end

  @required_fields ~w(aggregate_id amount)a

  @impl true
  def valid?(command) do
    data = Map.from_struct(command)

    # We are not returning a changeset, we are simply plucking off
    # the `valid?` key, which is a boolean.
    %__MODULE__{}
    |> cast(data, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:amount, greater_than: 0)
    |> Map.get(:valid?)
  end
end
