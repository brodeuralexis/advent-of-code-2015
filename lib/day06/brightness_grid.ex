defmodule Advent2015.Day06.BrightnessGrid do
  @moduledoc """
  A 2D grid of light brightness.
  """

  @type position :: {x :: non_neg_integer, y :: non_neg_integer}

  @type light_state :: :on | :off

  @type t :: %__MODULE__{
    lights: %{ required(position) => non_neg_integer }
  }

  defstruct [:lights]

  @doc """
  Creates a new brightness grid without any lights turned on.
  """
  @spec new(non_neg_integer, non_neg_integer) :: t
  def new(width \\ 1000, height \\ 1000) do
    %__MODULE__{
      lights: for x <- 0..(width - 1), y <- 0..(height - 1), into: %{} do
        {{x, y}, 0}
      end
    }
  end

  @doc """
  Sets the brightness between `:from` and `:to` according to the `light_state`.
  """
  @spec turn(t, light_state, from: position, to: position) :: t
  def turn(%__MODULE__{} = grid, light_state, from: from, to: to) do
    from
    |> all_positions(to)
    |> Enum.reduce(grid, fn position, grid ->
      case light_state do
        :on ->
          %{grid |
            lights: Map.update!(grid.lights, position, &(&1 + 1))
          }

        :off ->
          %{grid |
            lights: Map.update!(grid.lights, position, brightness_decrementer(1))
          }
      end
    end)
  end

  @doc """
  Toggles the brigtness between `:from` and `:to`.
  """
  @spec toggle(t, from: position, to: position) :: t
  def toggle(%__MODULE__{} = grid, from: from, to: to) do
    from
    |> all_positions(to)
    |> Enum.reduce(grid, fn position, grid ->
      %{grid |
        lights: Map.update!(grid.lights, position, &(&1 + 2))
      }
    end)
  end

  @doc """
  Returns the total brightness of the grid.
  """
  @spec total_brightness(t) :: number
  def total_brightness(%__MODULE__{lights: lights}) do
    lights
    |> Map.values()
    |> Enum.sum()
  end

  defp all_positions({from_x, from_y}, {to_x, to_y}) do
    for x <- from_x..to_x, y <- from_y..to_y do
      {x, y}
    end
  end

  @spec brightness_decrementer(number) :: (number -> number)
  def brightness_decrementer(by) do
    fn
      brightness when brightness >= by -> brightness - by
      _ -> 0
    end
  end
end
