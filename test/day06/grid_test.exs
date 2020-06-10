defmodule Advent2015.Day06.GridTest do
  use ExUnit.Case, async: true

  alias Advent2015.Day06.Grid
  import Grid

  doctest Grid

  describe "new/0" do
    test "creates a grid without any lit lights" do
      grid = new()

      assert lights_lit(grid) == 0
    end
  end

  describe "turn/3" do
    test "turns :on all the lights between 0,0 and 2,2" do
      grid = new() |> turn(:on, from: {0, 0}, to: {2, 2})

      assert lights_lit(grid) == 9
    end

    test ":on is a noop on lit lights" do
      grid = new() |> turn(:on, from: {0, 0}, to: {2, 2}) |> turn(:on, from: {1, 1}, to: {2, 2})

      assert lights_lit(grid) == 9
    end

    test "turns :off all the lights between 1,1 and 2,2" do
      grid = new() |> turn(:on, from: {0, 0}, to: {2, 2}) |> turn(:off, from: {1, 1}, to: {2, 2})

      assert lights_lit(grid) == 5
    end

    test ":off is a noop on non lit lights" do
      grid = new() |> turn(:off, from: {1, 1}, to: {2, 2})

      assert lights_lit(grid) == 0
    end
  end

  describe "toggle/2" do
    test "toggles all the lights between 0,0 and 2,2" do
      grid = new() |> turn(:on, from: {0, 0}, to: {1, 1}) |> toggle(from: {0, 0}, to: {2, 2})

      assert lights_lit(grid) == 5
    end
  end
end
