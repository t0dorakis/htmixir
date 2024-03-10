defmodule Htmixir.ContactCache do
  use GenServer
  # Starting the GenServer
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # GenServer callback
  def init(:ok) do
    # Create the ETS table
    :ets.new(:contacts, [:named_table, :public])

    :ets.insert(
      :contacts,
      {1, %{first_name: "John", last_name: "Doe", email: "john.doe@example.com"}}
    )

    {:ok, %{}}
  end
end
