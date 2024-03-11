defmodule Htmixir.Router do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :json],
    pass: ["*/*"],
    json_decoder: Jason
  )

  plug(Plug.Static,
    at: "/assets",
    from: "priv/assets"
  )

  plug(:match)
  plug(:dispatch)

  get "/" do
    IO.inspect("Rendering index page")
    content = EEx.eval_file("templates/index.html.eex")
    send_resp(conn, 200, content)
  end

  get "/newsTicker" do
    [{_id, contact}] = :ets.lookup(:contacts, 1)
    # get news ticker content
    {news_item, _next_news_number} = GenServer.call(Htmixir.NewsCache, :get_news_ticker)

    IO.inspect("Rendering news ticker with #{inspect(news_item)}")

    content =
      EEx.eval_file("templates/news-ticker.html.eex",
        assigns: [contact: contact, news_item: news_item]
      )

    send_resp(conn, 200, content)
  end

  get "/contact/1" do
    [{_id, contact}] = :ets.lookup(:contacts, 1)
    IO.inspect("Rendering contact with #{inspect(contact)}")
    content = EEx.eval_file("templates/contact.html.eex", assigns: [contact: contact])
    send_resp(conn, 200, content)
  end

  get "contact/1/edit" do
    [{_id, contact}] = :ets.lookup(:contacts, 1)
    IO.inspect("Rendering contact edit form with #{inspect(contact)}")
    content = EEx.eval_file("templates/contact-edit.html.eex", assigns: [contact: contact])
    send_resp(conn, 200, content)
  end

  put "contact/1" do
    contact = %{
      first_name: conn.body_params["firstName"],
      last_name: conn.body_params["lastName"],
      email: conn.body_params["email"]
    }

    IO.inspect("Updating contact with #{inspect(contact)}")

    :ets.insert(:contacts, {1, contact})
    content = EEx.eval_file("templates/contact.html.eex", assigns: [contact: contact])
    send_resp(conn, 200, content)
  end

  match _ do
    conn
    |> send_resp(404, "Not found")
  end
end
