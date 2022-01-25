# Bank

A simple little application to show off Event Sourcing in Elixir with
the intent to not dictate a particular library. `Incident` is used in
this example for the simple sake that it leverages Ecto versus EventStoreDB.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `bank` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:bank, "~> 0.1.0"}
  ]
end
```

## How to explore the code

```
# Create a command to open an account
iex 1 > command_open = %Bank.Commands.OpenAccount{aggregate_id: Ecto.UUID.generate()}
%Bank.Commands.OpenAccount{aggregate_id: "10f60355-9a81-47d0-ab0c-3ebedab0bbf3"}

# Successful command for opening an account
iex 2 > Bank.BankAccountCommandHandler.receive(command_open)
{:ok,
 %Incident.EventStore.PostgresEvent{
   __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
   aggregate_id: "10f60355-9a81-47d0-ab0c-3ebedab0bbf3",
   event_data: %{
     "account_number" => "10f60355-9a81-47d0-ab0c-3ebedab0bbf3",
     "aggregate_id" => "10f60355-9a81-47d0-ab0c-3ebedab0bbf3",
     "version" => 1
   },
   event_date: #DateTime<2020-10-31 23:17:30.074416Z>,
   event_id: "072fcfce-9521-4432-a2e0-517659590556",
   event_type: "AccountOpened",
   id: 5,
   inserted_at: #DateTime<2020-10-31 23:17:30.087480Z>,
   updated_at: #DateTime<2020-10-31 23:17:30.087480Z>,
   version: 1
}}

# Failed command as the account number already exists
iex 3 > Bank.BankAccountCommandHandler.receive(command_open)
{:error, :account_already_open}

# Fetching a specific bank account from the Projection Store based on its aggregate id
iex 4 > Incident.ProjectionStore.get(Bank.Projections.BankAccount, "10f60355-9a81-47d0-ab0c-3ebedab0bbf3")
%Bank.Projections.BankAccount{
  __meta__: #Ecto.Schema.Metadata<:loaded, "bank_accounts">,
  account_number: "10f60355-9a81-47d0-ab0c-3ebedab0bbf3",
  aggregate_id: "10f60355-9a81-47d0-ab0c-3ebedab0bbf3",
  balance: 0,
  event_date: #DateTime<2020-10-31 23:17:30.074416Z>,
  event_id: "072fcfce-9521-4432-a2e0-517659590556",
  id: 2,
  inserted_at: #DateTime<2020-10-31 23:17:30.153274Z>,
  updated_at: #DateTime<2020-10-31 23:17:30.153274Z>,
  version: 1
}

# Fetching all events for a specific aggregate id
iex 5 > Incident.EventStore.get("10f60355-9a81-47d0-ab0c-3ebedab0bbf3")
[
  %Incident.EventStore.PostgresEvent{
    __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
    aggregate_id: "10f60355-9a81-47d0-ab0c-3ebedab0bbf3",
    event_data: %{
      "account_number" => "10f60355-9a81-47d0-ab0c-3ebedab0bbf3",
      "aggregate_id" => "10f60355-9a81-47d0-ab0c-3ebedab0bbf3",
      "version" => 1
    },
    event_date: #DateTime<2020-10-31 23:17:30.074416Z>,
    event_id: "072fcfce-9521-4432-a2e0-517659590556",
    event_type: "AccountOpened",
    id: 5,
    inserted_at: #DateTime<2020-10-31 23:17:30.087480Z>,
    updated_at: #DateTime<2020-10-31 23:17:30.087480Z>,
    version: 1
  }
]
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/bank](https://hexdocs.pm/bank).
