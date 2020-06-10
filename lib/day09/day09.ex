defmodule Advent2015.Day09 do
  alias Advent2015.Day09.Graph
  alias Advent2015.Day09.Decoder
  alias Advent2015.Day09.TravellingSalesman

  @puzzle_input File.read!("#{__DIR__}/puzzle_input.txt")

  @spec day09 :: nil
  def day09 do
    part01()
    part02()
    nil
  end

  defp part01 do
    @puzzle_input
    |> Decoder.decode_links()
    |> Enum.reduce(Graph.new(), fn {first, second, weight}, graph ->
      Graph.link(graph, first, second, weight)
    end)
    |> TravellingSalesman.hamiltonian_paths()
    |> Enum.min_by(&elem(&1, 1))
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> Decoder.decode_links()
    |> Enum.reduce(Graph.new(), fn {first, second, weight}, graph ->
      Graph.link(graph, first, second, weight)
    end)
    |> TravellingSalesman.hamiltonian_paths()
    |> Enum.max_by(&elem(&1, 1))
    |> IO.inspect(label: "part02")
  end
end
