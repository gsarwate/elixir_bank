defmodule Bank.Customer.Database do
  use GenServer

  @db_folder "./data/customer"

  # Client

  def start_link(_) do
    IO.puts("--> Start : Bank Customer Database.")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Bank.Customer.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Bank.Customer.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
  end

  # Server (callbacks)

  @impl true
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end

  @impl true
  def handle_call({:choose_worker, key}, _from, workers) do
    worker_key = :erlang.phash2(key, 3)
    {:reply, Map.get(workers, worker_key), workers}
  end

  defp start_workers() do
    for index <- 1..3, into: %{} do
      {:ok, pid} = Bank.Customer.DatabaseWorker.start_link(@db_folder)
      {index - 1, pid}
    end
  end
end
