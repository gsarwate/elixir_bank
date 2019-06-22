defmodule Bank.Customer do
  defstruct auto_id: 1, accounts: %{}

  @doc """
  Defines a function to create new bank customer
  """
  def new(accounts \\ []) do
    Enum.reduce(accounts, %Bank.Customer{}, &add_account(&2, &1))
  end

  @doc """
  Defines a function to add new account for the bank customer
  """
  def add_account(customer, %Bank.Account{} = account) do
    account = Map.put(account, :id, customer.auto_id)
    new_accounts = Map.put(customer.accounts, customer.auto_id, account)

    %Bank.Customer{customer | accounts: new_accounts, auto_id: customer.auto_id + 1}
  end

  @doc """
  Defines a function to get account by account id
  """
  def get_account_by_id(customer, account_id) do
    customer.accounts
    |> Enum.filter(fn {id, _} -> id == account_id end)
    |> Enum.map(fn {_, account} -> account end)
  end

  @doc """
  Defines function to get all accounts for the bank customer
  """
  def get_accounts(customer), do: customer.accounts

  @doc """
  Defines function to update account for the bank customer
  """
  def update_account(customer, %Bank.Account{} = updated_account) do
    update_account(customer, updated_account.id, fn _ -> updated_account end)
  end

  @doc """
  Defines function to update account for the bank customer using provided update function
  """
  def update_account(customer, account_id, update_function) do
    case Map.fetch(customer.accounts, account_id) do
      :error ->
        customer

      {:ok, old_account} ->
        updated_account = update_function.(old_account)
        new_accounts = Map.put(customer.accounts, updated_account.id, updated_account)
        %Bank.Customer{customer | accounts: new_accounts}
    end
  end

  @doc """
  Defines function to delete account by id
  """
  def delete_account_by_id(customer, account_id) do
    %Bank.Customer{customer | accounts: Map.delete(customer.accounts, account_id)}
  end
end
