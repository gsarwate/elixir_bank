defmodule Bank.Customer.Cache do
  @moduledoc """
  Cache server to track servers started uisng Customer server. It maintains state in a map of {customer_id => customer_server}
  """
  use GenServer

  # Client

  def start_link(_) do
    IO.puts("--> Start : Bank Customer Cache.")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(customer_id) do
    GenServer.call(__MODULE__, {:server_process, customer_id})
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:server_process, customer_id}, _from, bank_customer_servers) do
    case Map.fetch(bank_customer_servers, customer_id) do
      {:ok, customer_server} ->
        {:reply, customer_server, bank_customer_servers}

      :error ->
        {:ok, new_server} = Bank.Customer.Server.start_link(customer_id)
        {:reply, new_server, Map.put(bank_customer_servers, customer_id, new_server)}
    end
  end
end
