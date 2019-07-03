defmodule Bank.Customer.AServer do
  use Agent, restart: :temporary

  def start_link(customer_id) do
    Agent.start_link(
      fn ->
        IO.puts("Start -> Bank Customer Server for #{customer_id}")
        {customer_id, Bank.Customer.Database.get(customer_id) || Bank.Customer.new(customer_id)}
      end,
      name: via_tuple(customer_id)
    )
  end

  def add_account(bank_server, new_account) do
    Agent.cast(bank_server, fn {customer_id, customer} ->
      updated_customer = Bank.Customer.add_account(customer, new_account)
      Bank.Customer.Database.store(customer_id, updated_customer)
      {customer_id, updated_customer}
    end)
  end

  def accounts(bank_server) do
    Agent.get(
      bank_server,
      fn {_customer_id, customer} -> Bank.Customer.get_accounts(customer) end
    )
  end

  defp via_tuple(customer_id) do
    Bank.Customer.ProcessRegistry.via_tuple({__MODULE__, customer_id})
  end
end
