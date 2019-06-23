defmodule BankCustomerCacheTest do
  use ExUnit.Case

  alias Bank.Customer.Cache
  alias Bank.Customer.Server

  test "customer server process" do
    {:ok, cache} = Cache.start()
    server_pid_customer_123 = Cache.server_process(cache, 123)

    assert server_pid_customer_123 == Cache.server_process(cache, 123)
    refute server_pid_customer_123 == Cache.server_process(cache, 321)
  end

  test "customer operations" do
    {:ok, cache} = Cache.start()
    server_pid_customer_123 = Cache.server_process(cache, 123)

    account_987 = %Bank.Account{number: 987, type: "CHK", balance: 100_00}
    Server.add_account(server_pid_customer_123, account_987)
    accounts = Server.accounts(server_pid_customer_123)

    assert [%{number: 987, type: "CHK", balance: 100_00}] = accounts
  end
end
