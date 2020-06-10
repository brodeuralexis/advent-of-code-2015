defmodule Advent2015.Day06.Grid do
  @moduledoc """
  A 2D grid of lights, represented as a map.
  """

  @type position :: {x :: non_neg_integer, y :: non_neg_integer}

  @type light_state :: :on | :off

  @opaque t :: %__MODULE__{
    lights: MapSet.t
  }

  defstruct [:lights]

  @doc """
  Creates a new grid of lights without any lights on.
  """
  @spec new :: t
  def new do
    %__MODULE__{
      lights: MapSet.new,
    }
  end

  @doc """
  Turns all the lights in the rectangle between `:from` and `:to` to the given
  `light_state`.
  """
  @spec turn(t, light_state, from: position, to: position) :: t
  def turn(%__MODULE__{} = grid, light_state, from: from, to: to) do
    from
    |> all_positions(to)
    |> Enum.reduce(grid, fn position, grid ->
      case light_state do
        :on ->
          %{grid |
            lights: MapSet.put(grid.lights, position)
          }

        :off ->
          %{grid |
            lights: MapSet.delete(grid.lights, position)
          }
      end
    end)
  end

  @doc """
  Toggles all the lights between `:from` and `:to`.
  """
  @spec toggle(t, from: position, to: position) :: t
  def toggle(%__MODULE__{} = grid, from: from, to: to) do
    from
    |> all_positions(to)
    |> Enum.reduce(grid, fn position, grid ->
      if MapSet.member?(grid.lights, position) do
        %{grid |
          lights: MapSet.delete(grid.lights, position)
        }
      else
        %{grid |
          lights: MapSet.put(grid.lights, position)
        }
      end
    end)
  end

  @doc """
  Returns the number of lights that are lit.
  """
  @spec lights_lit(t) :: non_neg_integer
  def lights_lit(%__MODULE__{lights: lights}) do
    Enum.count(lights)
  end

  defp all_positions({from_x, from_y}, {to_x, to_y}) do
    for x <- from_x..to_x, y <- from_y..to_y do
      {x, y}
    end
  end
end
