defmodule Bank.Application do
  use Application

  def start(_type, _args) do
    Bank.System.start_link()
  end
end
