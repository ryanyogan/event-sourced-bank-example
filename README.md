# Bank

A simple little application to show off Event Sourcing in Elixir with
the intent to not dictate a particular library. `Incident` is used in
this example for the simple sake that it leverages Ecto versus EventStoreDB.

## What is Event Sourcing, and what the hell is CQRS?!

I cannot recommend enough the following resources are understood first,
please ensure this is a route one wants to go, and these type of solutions truly lend well to the challenge at hand:

**WARNING** Seriously, once you go ES, going back is very difficult!

- https://martinfowler.com/eaaDev/EventSourcing.html (Read: Martin Fowler)
- https://www.youtube.com/watch?v=JHGkaShoyNs (Watch: Greg Young)

### Let's Play via IEX

```
iex -S mix
```

#### Let's generate an account number for the new bank account

```
iex 1 > account_number = Ecto.UUID.generate()
"f004d517-8b86-45b4-bdfa-29ac41dd3f51"
iex 2 > command_open = %Bank.Commands.OpenAccount{aggregate_id: account_number}
%Bank.Commands.OpenAccount{aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51"}
```

#### Opening a new bank account

```
iex 3 > Bank.BankAccountCommandHandler.receive(command_open)
{:ok,
 %Incident.EventStore.Postgres.Event{
   __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
   aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
   event_data: %{
     "account_number" => "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
     "aggregate_id" => "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
     "version" => 1
   },
   event_date: #DateTime<2020-12-11 16:23:08.162372Z>,
   event_id: "369cc1d0-e973-42b8-99bf-a15025936fb2",
   event_type: "AccountOpened",
   id: 90,
   inserted_at: #DateTime<2020-12-11 16:23:08.162457Z>,
   version: 1
 }}
```

#### If we read from the projection we get the current state of the account

```
iex 4 > Incident.ProjectionStore.get(Bank.Projections.BankAccount, account_number)
%Bank.Projections.BankAccount{
 __meta__: #Ecto.Schema.Metadata<:loaded, "bank_accounts">,
 account_number: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
 aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
 balance: 0,
 event_date: #DateTime<2020-12-11 16:23:08.162372Z>,
 event_id: "369cc1d0-e973-42b8-99bf-a15025936fb2",
 id: 2,
 inserted_at: #DateTime<2020-12-11 16:23:08.189004Z>,
 updated_at: #DateTime<2020-12-11 16:23:08.189004Z>,
 version: 1
}
```

#### Let's create a command for depositing money

```
iex 5 > command_deposit = %Bank.Commands.DepositMoney{aggregate_id: account_number, amount: 100}
%Bank.Commands.DepositMoney{
  aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
  amount: 100
}
```

#### Depositing money

```
iex 6 > Bank.BankAccountCommandHandler.receive(command_deposit)
{:ok,
 %Incident.EventStore.Postgres.Event{
   __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
   aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
   event_data: %{
     "aggregate_id" => "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
     "amount" => 100,
     "version" => 2
   },
   event_date: #DateTime<2020-12-11 16:31:36.460303Z>,
   event_id: "ce4f72b9-d3ec-47c9-8533-9216c59803e6",
   event_type: "MoneyDeposited",
   id: 91,
   inserted_at: #DateTime<2020-12-11 16:31:36.460401Z>,
   version: 2
 }}
```

#### Let's make another deposit (same command for brevity)

```
iex 7 > Bank.BankAccountCommandHandler.receive(command_deposit)
{:ok,
 %Incident.EventStore.Postgres.Event{
   __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
   aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
   event_data: %{
     "aggregate_id" => "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
     "amount" => 100,
     "version" => 3
   },
   event_date: #DateTime<2020-12-11 16:33:29.432375Z>,
   event_id: "618903b5-8304-4151-a94d-43ed0b763c39",
   event_type: "MoneyDeposited",
   id: 92,
   inserted_at: #DateTime<2020-12-11 16:33:29.432486Z>,
   version: 3
 }}
```

#### We can list all events for the aggregate id

```
iex 8> Incident.EventStore.get(account_number)
[
  %Incident.EventStore.Postgres.Event{
    __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
    aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
    event_data: %{
      "account_number" => "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
      "aggregate_id" => "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
      "version" => 1
    },
    event_date: #DateTime<2020-12-11 16:23:08.162372Z>,
    event_id: "369cc1d0-e973-42b8-99bf-a15025936fb2",
    event_type: "AccountOpened",
    id: 90,
    inserted_at: #DateTime<2020-12-11 16:23:08.162457Z>,
    version: 1
  },
  %Incident.EventStore.Postgres.Event{
    __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
    aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
    event_data: %{
      "aggregate_id" => "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
      "amount" => 100,
      "version" => 2
    },
    event_date: #DateTime<2020-12-11 16:31:36.460303Z>,
    event_id: "ce4f72b9-d3ec-47c9-8533-9216c59803e6",
    event_type: "MoneyDeposited",
    id: 91,
    inserted_at: #DateTime<2020-12-11 16:31:36.460401Z>,
    version: 2
  },
  %Incident.EventStore.Postgres.Event{
    __meta__: #Ecto.Schema.Metadata<:loaded, "events">,
    aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
    event_data: %{
      "aggregate_id" => "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
      "amount" => 100,
      "version" => 3
    },
    event_date: #DateTime<2020-12-11 16:33:29.432375Z>,
    event_id: "618903b5-8304-4151-a94d-43ed0b763c39",
    event_type: "MoneyDeposited",
    id: 92,
    inserted_at: #DateTime<2020-12-11 16:33:29.432486Z>,
    version: 3
  }
]
```

### Now, after the 2 deposits we made, the projection is properly updated.

**Note the version, event_date and event_id fields that are related to the last event that updated the projection.**

```
iex 9> Incident.ProjectionStore.get(Bank.Projections.BankAccount, account_number)
%Bank.Projections.BankAccount{
  __meta__: #Ecto.Schema.Metadata<:loaded, "bank_accounts">,
  account_number: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
  aggregate_id: "f004d517-8b86-45b4-bdfa-29ac41dd3f51",
  balance: 200,
  event_date: #DateTime<2020-12-11 16:33:29.432375Z>,
  event_id: "618903b5-8304-4151-a94d-43ed0b763c39",
  id: 2,
  inserted_at: #DateTime<2020-12-11 16:23:08.189004Z>,
  updated_at: #DateTime<2020-12-11 16:33:29.438631Z>,
  version: 3
}
```
