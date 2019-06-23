defmodule Bank.CustomerServer do
  use GenServer

  # Client

  @doc """
  Defines a function to start a server(GenServer). For every customer new server is created
  """
  def start(id) do
    GenServer.start(Bank.CustomerServer, id)
  end

  @doc """
  Defines a function to add customer account
  """
  def add_account(bank_server, new_account) do
    GenServer.cast(bank_server, {:add_account, new_account})
  end

  @doc """
  Defines a function to get all accounts for the customer
  """
  def accounts(bank_server) do
    GenServer.call(bank_server, {:accounts})
  end

  @doc """
  Defines a function to get customer account by account id
  """
  def account_by_id(bank_server, id) do
    GenServer.call(bank_server, {:account_by_id, id})
  end

  @doc """
  Defines a function to get customer account by account number
  """
  def account_by_number(bank_server, account_number) do
    GenServer.call(bank_server, {:account_by_number, account_number})
  end

  # Server (callbacks)

  @impl true
  def init(id) do
    {:ok, Bank.Customer.new(id)}
  end

  @impl true
  def handle_cast({:add_account, new_account}, customer) do
    new_state = Bank.Customer.add_account(customer, new_account)
    {:noreply, new_state}
  end

  @impl true
  def handle_call({:accounts}, _from, customer) do
    {:reply, Bank.Customer.get_accounts(customer), customer}
  end

  @impl true
  def handle_call({:account_by_id, id}, _from, customer) do
    {:reply, Bank.Customer.get_account_by_id(customer, id), customer}
  end

  @impl true
  def handle_call({:account_by_number, account_number}, _from, customer) do
    {:reply, Bank.Customer.get_account_by_number(customer, account_number), customer}
  end
end
