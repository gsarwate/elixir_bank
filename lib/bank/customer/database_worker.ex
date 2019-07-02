defmodule Bank.Customer.DatabaseWorker do
  use GenServer

  # Client

  def start_link({db_folder, worker_id}) do
    IO.puts("--> Start : Bank Customer Database Worker #{worker_id}.")
    GenServer.start_link(
      __MODULE__,
      db_folder,
      name: via_tuple(worker_id))
  end

  def store(worker_pid, key, data) do
    GenServer.cast(via_tuple(worker_pid), {:store, key, data})
  end

  def get(worker_pid, key) do
    GenServer.call(via_tuple(worker_pid), {:get, key})
  end

  defp via_tuple(worker_id) do
    Bank.Customer.ProcessRegistry.via_tuple({__MODULE__, worker_id})
  end

  # Server (callbacks)

  @impl true
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl true
  def handle_cast({:store, key, data}, db_folder) do
    db_folder
    |> filename(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, db_folder}
  end

  @impl true
  def handle_call({:get, key}, _from, db_folder) do
    data =
      case File.read(filename(db_folder, key)) do
        {:ok, content} -> :erlang.binary_to_term(content)
        _ -> nil
      end

    {:reply, data, db_folder}
  end

  defp filename(db_folder, key) do
    Path.join(db_folder, to_string(key))
  end
end
