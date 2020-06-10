defmodule Advent2015.Day09.TravellingSalesman do
  alias Advent2015.Day09.Graph

  @type path :: [Graph.city]
  @type weight :: non_neg_integer

  @doc """
  Returns a list of all hamiltonian paths and their respective weights.

  ## Example

      iex(1)> graph =
      ...(1)>   Graph.new()
      ...(1)>   |> Graph.link("London", "Dublin", 464)
      ...(1)>   |> Graph.link("London", "Belfast", 518)
      ...(1)>   |> Graph.link("Dublin", "Belfast", 141)
      iex(2)> hamiltonian_paths(graph) |> Enum.into(%{})
      %{
        ["Dublin", "London", "Belfast"] => 982,
        ["London", "Dublin", "Belfast"] => 605,
        ["London", "Belfast", "Dublin"] => 659,
        ["Dublin", "Belfast", "London"] => 659,
        ["Belfast", "Dublin", "London"] => 605,
        ["Belfast", "London", "Dublin"] => 982
      }
  """
  @spec hamiltonian_paths(Graph.t) :: [{path, weight}]
  def hamiltonian_paths(graph) do
    graph
    |> Graph.cities()
    |> permutations()
    |> Enum.map(fn path ->
      {path, evaluate_path(graph, path)}
    end)
    |> Enum.filter(&(not is_nil(elem(&1, 1))))
  end

  defp evaluate_path(graph, path) do
    do_evaluate_path(graph, path, 0)
  end

  defp do_evaluate_path(_graph, [_], weight) do
    weight
  end

  defp do_evaluate_path(graph, [first | [second | _] = cities], weight) do
    links = Graph.links(graph, first)

    case Map.fetch(links, second) do
      {:ok, link_weight} ->
        do_evaluate_path(graph, cities, weight + link_weight)

      :error ->
        nil
    end
  end

  defp permutations([]) do
     [[]]
  end

  defp permutations(list) do
    for elem <- list, rest <- permutations(list -- [elem]) do
      [elem | rest]
    end
  end
end
