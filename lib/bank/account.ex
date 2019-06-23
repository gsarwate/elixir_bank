defmodule Bank.Account do
  @enforce_keys [:number, :type]
  defstruct id: 0, number: nil, type: nil, balance: 0
end
