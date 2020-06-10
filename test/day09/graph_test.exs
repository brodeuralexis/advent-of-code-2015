defmodule Advent2015.Day09.GraphTest do
  use ExUnit.Case, async: true

  alias Advent2015.Day09.Graph

  doctest Graph

  describe "new/0" do
    test "create an empty graph" do
      assert Graph.new() == %{}
    end
  end

  describe "link/4" do
    test "links 2 cities together" do
      graph = Graph.new() |> Graph.link("a", "b", 1) |> Graph.link("b", "c", 2)

      assert Graph.links(graph, "a") == %{"b" => 1}
      assert Graph.links(graph, "b") == %{"a" => 1, "c" => 2}
      assert Graph.links(graph, "c") == %{"b" => 2}
    end
  end

  describe "links/2" do
    test "returns the links for a city" do
      graph = Graph.new() |> Graph.link("a", "b", 1) |> Graph.link("b", "c", 2)

      assert Graph.links(graph, "a") == %{"b" => 1}
      assert Graph.links(graph, "b") == %{"a" => 1, "c" => 2}
      assert Graph.links(graph, "c") == %{"b" => 2}
    end
  end

  describe "cities/1" do
    test "returns the cities in the graph" do
      graph = Graph.new() |> Graph.link("a", "b", 1) |> Graph.link("b", "c", 2)

      assert Graph.cities(graph) == ["a", "b", "c"]
    end
  end
end
