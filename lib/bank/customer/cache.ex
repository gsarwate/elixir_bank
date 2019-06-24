defmodule Bank.Customer.Cache do
  @moduledoc """
  Cache server to track servers started uisng Customer server. It maintains state in a map of {customer_id => customer_server}
  """
  use GenServer

  # Client

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def server_process(cache_pid, customer_id) do
    GenServer.call(cache_pid, {:server_process, customer_id})
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    Bank.Customer.Database.start()
    {:ok, %{}}
  end

  @impl true
  def handle_call({:server_process, customer_id}, _from, bank_customer_servers) do
    case Map.fetch(bank_customer_servers, customer_id) do
      {:ok, customer_server} ->
        {:reply, customer_server, bank_customer_servers}

      :error ->
        {:ok, new_server} = Bank.Customer.Server.start(customer_id)
        {:reply, new_server, Map.put(bank_customer_servers, customer_id, new_server)}
    end
  end
end
