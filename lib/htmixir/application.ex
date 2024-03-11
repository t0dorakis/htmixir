defmodule Htmixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {
        Htmixir.ContactCache,
        name: Htmixir.ContactCache
      },
      {
        Htmixir.NewsCache,
        name: Htmixir.NewsCache
      },
      {Bandit, plug: Htmixir.Router}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Htmixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
