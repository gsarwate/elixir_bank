defmodule Bank.Customer.Database do
  use GenServer

  @db_folder "./data/customer"

  # Client

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.cast(__MODULE__, {:store, key, data})
  end

  def get(id) do
    GenServer.call(__MODULE__, {:get, id})
  end
  # Server (callbacks)

  @impl true
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, nil}
  end

  @impl true
  def handle_cast({:store, key, data}, state) do
    key
    |> filename()
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    data =
      case File.read(filename(key)) do
        {:ok, content} -> :erlang.binary_to_term(content)
        _ -> nil
      end

    {:reply, data, state}
  end

  defp filename(key) do
    Path.join(@db_folder, to_string(key))
  end
end
