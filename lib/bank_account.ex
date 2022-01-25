defmodule Bank.BankAccount do
  @behaviour Incident.Aggregate

  alias Bank.BankAccountState
  alias Bank.Commands.OpenAccount
  alias Bank.Events.AccountOpened

  @impl true
  def execute(%OpenAccount{aggregate_id: aggregate_id}) do
    case BankAccountState.get(aggregate_id) do
      %{account_number: nil} = state ->
        new_event = %AccountOpened{
          aggregate_id: aggregate_id,
          account_number: aggregate_id,
          version: 1
        }

        {:ok, new_event, state}

      _state ->
        {:error, :account_already_opened}
    end
  end

  @impl true
  def apply(%{event_type: "AccountOpened"} = event, state) do
    %{
      state
      | aggregate_id: event.aggregate_id,
        account_number: event.event_data["account_number"],
        balance: 0,
        version: event.version,
        updated_at: event.event_date
    }
  end
end
