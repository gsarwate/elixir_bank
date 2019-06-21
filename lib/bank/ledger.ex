defmodule Bank.Ledger do
  defstruct auto_id: 1, accounts: %{}

  @doc """
  Defines a function to create new Bank.Ledger
  """
  def new(accounts \\ []) do
    Enum.reduce(accounts, %Bank.Ledger{}, &add_account(&2, &1))
  end

  @doc """
  Defines a function to add new account to the ledger
  """
  def add_account(bank_ledger, %Bank.Account{} = account) do
    account = Map.put(account, :id, bank_ledger.auto_id)
    new_accounts = Map.put(bank_ledger.accounts, bank_ledger.auto_id, account)

    %Bank.Ledger{bank_ledger | accounts: new_accounts, auto_id: bank_ledger.auto_id + 1}
  end

  @doc """
  Defines a function to get account by account id
  """
  def get_account_by_id(bank_ledger, account_id) do
    bank_ledger.accounts
    |> Enum.filter(fn {id, _} -> id == account_id end)
    |> Enum.map(fn {_, account} -> account end)
  end

  @doc """
  Defines function to get all accounts in a ledger
  """
  def get_accounts(bank_ledger), do: bank_ledger.accounts

  @doc """
  Defines function to update account in a ledger
  """
  def update_account(bank_ledger, %Bank.Account{} = updated_account) do
    update_account(bank_ledger, updated_account.id, fn _ -> updated_account end)
  end

  @doc """
  Defines function to update account in a ledger using provided update function
  """
  def update_account(bank_ledger, account_id, update_function) do
    case Map.fetch(bank_ledger.accounts, account_id) do
      :error ->
        bank_ledger

      {:ok, old_account} ->
        updated_account = update_function.(old_account)
        new_accounts = Map.put(bank_ledger.accounts, updated_account.id, updated_account)
        %Bank.Ledger{bank_ledger | accounts: new_accounts}
    end
  end

  @doc """
  Defines function to delete account by id
  """
  def delete_account_by_id(bank_ledger, account_id) do
    %Bank.Ledger{bank_ledger | accounts: Map.delete(bank_ledger.accounts, account_id)}
  end
end
