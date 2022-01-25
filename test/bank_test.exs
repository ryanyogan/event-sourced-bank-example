defmodule BankTest do
  use ExUnit.Case

  describe "open_account/0" do
    test "open_account/0 creates a new account with a unique ID" do
      {:ok, account} = Bank.open_account()
      assert is_binary(account)
    end
  end
end
