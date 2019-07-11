defmodule Bank.Customer.Cache do
  @moduledoc """
  Cache Dynamic Supervisor to start servers(children) uisng Customer server
  """

  def start_link() do
    IO.puts("--> Start : Bank Customer Cache.")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def server_process(customer_id) do
    existing_process(customer_id) || new_process(customer_id)
  end

  defp existing_process(customer_id) do
    Bank.Customer.Server.whereis(customer_id)
  end

  defp new_process(customer_id) do
    case DynamicSupervisor.start_child(
           __MODULE__,
           {Bank.Customer.Server, customer_id}
         ) do
      {:ok, pid} ->
        pid

      {:error, {:already_started, pid}} ->
        pid
    end
  end
end
