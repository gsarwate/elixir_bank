defmodule Bank.System do
  def start_link do
    Supervisor.start_link(
      [
        Bank.Customer.ProcessRegistry,
        Bank.Customer.Database,
        Bank.Customer.Cache,
        Bank.Customer.Web
      ],
      strategy: :one_for_one
    )
  end
end
