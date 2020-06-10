defmodule Advent2015.Day09.Graph do
  @moduledoc """
  A module declaring a simple undirected graph of weighed nodes.
  """

  @typedoc """
  A city in the graph.
  """
  @type city :: String.t

  @type links :: %{optional(city) => non_neg_integer}

  @typedoc """
  The type of a graph.
  """
  @opaque t :: %{
    optional(city) => links
  }

  @spec new :: t
  def new do
    %{}
  end

  @doc """
  Links 2 cities together with a given weight.
  """
  @spec link(t, city, city, non_neg_integer) :: t
  def link(graph, first, second, weight) do
    first_links = Map.get(graph, first, %{ second => weight })
    second_links = Map.get(graph, second, %{ first => weight })

    graph
    |> Map.update(first, first_links, &Map.put(&1, second, weight))
    |> Map.update(second, second_links, &Map.put(&1, first, weight))
  end

  @doc """
  Returns the links that a city has on the graph.
  """
  @spec links(t, city) :: links
  def links(graph, city) do
    Map.get(graph, city, %{})
  end

  @doc """
  Returns a set of all cities in this graph.
  """
  @spec cities(t) :: [city]
  def cities(graph) do
    Map.keys(graph)
  end
end
