defmodule Htmixir.NewsCache do
  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call(:get_news_ticker, _from, state) do
    news_ticker = [
      "The first computer bug was an actual bug - a moth found trapped in a computer relay. The term \"bug\" was coined by Grace Hopper.",
      "The first computer mouse was invented by Doug Engelbart in around 1964 and was made of wood.",
      "The first computer virus was created in 1983 and was called the Elk Cloner. It was created by a 15-year-old high school student."
    ]

    current_news_number = Map.get(state, :current_news_number, 0)
    next_news_number = rem(current_news_number + 1, length(news_ticker))

    news_item = Enum.at(news_ticker, next_news_number)

    {:reply, {news_item, next_news_number},
     Map.put(state, :current_news_number, next_news_number)}
  end
end
