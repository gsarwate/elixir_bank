defmodule Bank.Customer.Web do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  post "/add_account" do
    conn = Plug.Conn.fetch_query_params(conn)
    customer_id = Map.fetch!(conn.params, "customer_id")
    number = Map.fetch!(conn.params, "number")
    type = Map.fetch!(conn.params, "type")
    balance = Map.fetch!(conn.params, "balance")

    customer_id
    |> Bank.Customer.Cache.server_process()
    |> Bank.Customer.Server.add_account(%Bank.Account{
      number: number,
      type: type,
      balance: balance
    })

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "OK")
  end

  get "/accounts" do
    conn = Plug.Conn.fetch_query_params(conn)
    customer_id = Map.fetch!(conn.params, "customer_id")

    accounts =
      customer_id
      |> Bank.Customer.Cache.server_process()
      |> Bank.Customer.Server.accounts()

    formatted_accounts =
      accounts
      |> Enum.map(fn e -> "number: #{e.number}  type: #{e.type}  balance: #{e.balance}" end)
      |> Enum.join("\n")

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, formatted_accounts)
  end

  def child_spec(_arg) do
    Plug.Adapters.Cowboy.child_spec(
      scheme: :http,
      options: [port: 5454],
      plug: __MODULE__
    )
  end
end
