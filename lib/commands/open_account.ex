defmodule Bank.Commands.OpenAccount do
  @behaviour Incident.Command

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field(:aggregate_id, :string)
  end

  @required_fields ~w(aggregate_id)a

  @impl true
  def valid?(command) do
    data =
      Map.from_struct(command)
      |> IO.inspect()

    %__MODULE__{}
    |> cast(data, @required_fields)
    |> validate_required(@required_fields)
    |> Map.get(:valid?)
  end
end
