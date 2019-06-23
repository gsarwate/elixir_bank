defmodule BankCustomerServerTest do
  use ExUnit.Case
  doctest Bank.Customer.Server

  alias Bank.Customer.Server

  test "add and fetch account" do
    customer_id = 987
    {:ok, server} = Server.start(customer_id)

    account_9001 = %Bank.Account{number: 9001, type: "CHK", balance: 100_00}
    Server.add_account(server, account_9001)
    accounts = Server.accounts(server)

    assert [%{number: 9001, type: "CHK", balance: 100_00}] = accounts
  end

  test "account by account id" do
    customer_id = 456
    {:ok, server} = Server.start(customer_id)

    account_1001 = %Bank.Account{number: 1001, type: "CHK", balance: 100_00}
    Server.add_account(server, account_1001)
    account = Server.accounts(server) |> List.first()

    assert [%{number: 1001, type: "CHK", balance: 100_00}] =
             Server.account_by_id(server, account.id)
  end

  test "account by number" do
    customer_id = 123
    {:ok, server} = Server.start(customer_id)

    account_1001 = %Bank.Account{number: 2001, type: "CHK", balance: 100_00}
    Server.add_account(server, account_1001)

    assert [%{number: 2001, type: "CHK", balance: 100_00}] =
             Server.account_by_number(server, 2001)
  end
end
