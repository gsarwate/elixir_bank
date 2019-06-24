defmodule BankCustomerCacheTest do
  use ExUnit.Case

  alias Bank.Customer.Cache
  alias Bank.Customer.Server

  test "customer server process" do
    {:ok, cache} = Cache.start()
    customer_id = DateTime.utc_now() |> DateTime.to_unix(:nanosecond)
    customer_server_pid = Cache.server_process(cache, customer_id)

    assert customer_server_pid == Cache.server_process(cache, customer_id)
    customer_id = customer_id + 10
    refute customer_server_pid == Cache.server_process(cache, customer_id)
  end

  test "customer operations" do
    {:ok, cache} = Cache.start()
    customer_id = DateTime.utc_now() |> DateTime.to_unix(:nanosecond)
    customer_server_pid = Cache.server_process(cache, customer_id)

    account_987 = %Bank.Account{number: 987, type: "CHK", balance: 100_00}
    Server.add_account(customer_server_pid, account_987)
    accounts = Server.accounts(customer_server_pid)

    assert [%{number: 987, type: "CHK", balance: 100_00}] = accounts
  end
end
