defmodule Bank.System do
  def start_link do
    Supervisor.start_link(
      [
        Bank.Customer.Database,
        Bank.Customer.Cache
      ],
      strategy: :one_for_one
    )
  end
end
