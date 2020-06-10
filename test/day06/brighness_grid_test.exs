defmodule Advent2015.Day06.BrightnessGridTest do
  use ExUnit.Case, async: true

  alias Advent2015.Day06.BrightnessGrid
  import BrightnessGrid

  doctest BrightnessGrid

  @grid new(3, 3)

  describe "new/0" do
    test "creates a brightness grid without any lit lights" do
      grid = @grid

      assert total_brightness(grid) == 0
    end
  end

  describe "turn/3" do
    test "turns :on all increments by 1 the brightness of the lights between 0,0 and 2,2" do
      grid = @grid |> turn(:on, from: {0, 0}, to: {2, 2})

      assert total_brightness(grid) == 9

      grid = turn(grid, :on, from: {0, 0}, to: {2, 2})

      assert total_brightness(grid) == 18
    end

    test "turns :off all the lights between 1,1 and 2,2" do
      grid = @grid |> turn(:off, from: {1, 1}, to: {2, 2})

      assert total_brightness(grid) == 0

      grid =
        grid
        |> turn(:on, from: {1, 1}, to: {2, 2})
        |> turn(:on, from: {1, 1}, to: {2, 2})
        |> turn(:off, from: {1, 1}, to: {2, 2})

      assert total_brightness(grid) == 4
    end
  end

  describe "toggle/2" do
    test "increases by 2 the brightness of all the lights between 0,0 and 2,2" do
      grid = @grid |> toggle(from: {0, 0}, to: {2, 2})

      assert total_brightness(grid) == 18
    end
  end
end
