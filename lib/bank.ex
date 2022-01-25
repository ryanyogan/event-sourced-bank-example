defmodule Bank do
  @moduledoc """
  Documentation for `Bank`.
  """
  # This is not production code, please do not use UUID from Ecto
  # This is not a proper boundary layer, these functions know WAY too much.
  import Ecto.UUID, only: [generate: 0]
  alias Bank.Commands.{OpenAccount, DepositMoney}
  alias Bank.BankAccountCommandHandler, as: Handler

  def open_account(account_number \\ generate()) do
    with command_open <- %OpenAccount{aggregate_id: account_number},
         {:ok, _event} <- Handler.receive(command_open) do
      {:ok, account_number}
    else
      {:error, _reason} = error ->
        error
    end
  end

  def get_balance(account_number) do
    case Incident.ProjectionStore.get(Bank.Projections.BankAccount, account_number) do
      %Bank.Projections.BankAccount{} = account ->
        account

      {:error, _reason} = error ->
        error
    end
  end

  def deposit_money(account_number, amount) do
    with command_deposit <- %DepositMoney{aggregate_id: account_number, amount: amount},
         {:ok, _event} <- Handler.receive(command_deposit) do
      {:ok, account_number}
    else
      {:error, _reason} = error ->
        error
    end
  end
end
