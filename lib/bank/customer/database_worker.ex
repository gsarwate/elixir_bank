defmodule Bank.Customer.DatabaseWorker do
  use GenServer

  # Client

  def start(db_folder) do
    GenServer.start(__MODULE__, db_folder)
  end

  def store(worker_pid, key, data) do
    GenServer.cast(worker_pid, {:store, key, data})
  end

  def get(worker_pid, key) do
    GenServer.call(worker_pid, {:get, key})
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
