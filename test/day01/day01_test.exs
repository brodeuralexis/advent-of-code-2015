defmodule Advent2015.Day01Test do
  use ExUnit.Case, async: true

  import Advent2015.Day01

  doctest Advent2015.Day01

  @directions_tests [
    {3, "((("},
    {3, "(()(()("},
    {3, "))((((("},
    {-1, "())"},
    {-1, "))("},
    {-3, ")))"},
    {-3, ")())())"},
  ]

  describe "floor_after/1" do
    for {floor, directions} <- @directions_tests do
      test "\"#{directions}\" should lead at the floor #{floor}" do
        directions = decode_directions(unquote(directions))

        assert unquote(floor) = floor_after(directions)
      end
    end
  end
end
