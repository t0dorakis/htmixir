defmodule Htmixir.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  get "contact/1/edit" do
    [{_id, contact}] = :ets.lookup(:contacts, 1)
    content = EEx.eval_file("templates/contact-edit.html.eex", assigns: [contact: contact])
    send_resp(conn, 200, content)
  end

  match _ do
    conn
    |> send_resp(404, "Not found")
  end
end
