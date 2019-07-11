defmodule Bank.Customer.DatabaseWorker do
  use GenServer

  # Client

  def start_link(db_folder) do
    IO.puts("--> Start : Bank Customer Database Worker.")
    GenServer.start_link(__MODULE__, db_folder)
  end

  def store(pid, key, data) do
    GenServer.call(pid, {:store, key, data})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  # Server (callbacks)

  @impl true
  def init(db_folder) do
    {:ok, db_folder}
  end

  @impl true
  def handle_call({:store, key, data}, _, db_folder) do
    db_folder
    |> filename(key)
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, :ok, db_folder}
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
