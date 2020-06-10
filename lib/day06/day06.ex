defmodule Advent2015.Day06 do
  alias Advent2015.Day06.{
    Grid,
    BrightnessGrid
  }

  @type light_state :: :on | :off

  @type position :: {x :: non_neg_integer, y :: non_neg_integer}

  @typedoc """
  The operation to execute.
  """
  @type operation :: {:turn, light_state}
                   | :toggle

  @typedoc """
  A single instruction to apply to the grid.
  """
  @type instruction :: {operation, from :: position, to :: position}

  @puzzle_input File.read!("#{__DIR__}/puzzle_input.txt")

  @spec day06 :: nil
  def day06 do
    part01()
    part02()
    nil
  end

  defp part01 do
    @puzzle_input
    |> decode_instructions()
    |> Enum.reduce(Grid.new(), fn
      {{:turn, state}, from, to}, grid ->
        Grid.turn(grid, state, from: from, to: to)

      {:toggle, from, to}, grid ->
        Grid.toggle(grid, from: from, to: to)
    end)
    |> Grid.lights_lit()
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> decode_instructions()
    |> Enum.reduce(BrightnessGrid.new(), fn
      {{:turn, state}, from, to}, grid ->
        BrightnessGrid.turn(grid, state, from: from, to: to)

      {:toggle, from, to}, grid ->
        BrightnessGrid.toggle(grid, from: from, to: to)
    end)
    |> BrightnessGrid.total_brightness()
    |> IO.inspect(label: "part02")
  end

  @doc """
  Decodes a string containing newline separated instructions.

  ## Example

      iex> decode_instructions("turn on 0,0 through 999,999\\ntoggle 0,0 through 999,0\\nturn off 499,499 through 500,500")
      [
        {{:turn, :on}, {0, 0}, {999, 999}},
        {:toggle, {0, 0}, {999, 0}},
        {{:turn, :off}, {499, 499}, {500, 500}}
      ]
  """
  @spec decode_instructions(String.t) :: [instruction]
  def decode_instructions(string) do
    string
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(&decode_instruction/1)
  end

  defp decode_instruction({string, index}) do
    string
    |> String.split(" ", parts: 6)
    |> case do
      ["turn", "on", from, "through", to] ->
        {{:turn, :on}, decode_position(from, index), decode_position(to, index)}

      ["turn", "off", from, "through", to] ->
        {{:turn, :off}, decode_position(from, index), decode_position(to, index)}

      ["toggle", from, "through", to] ->
        {:toggle, decode_position(from, index), decode_position(to, index)}
    end
  end

  defp decode_position(string, index) do
    string
    |> String.split(",", parts: 3)
    |> case do
      [x, y] ->
        x = case Integer.parse(x) do
          {x, ""} ->
            x

          _ ->
            raise ArgumentError, message: "Invalid x coordinate on line #{index}"
        end

        y = case Integer.parse(y) do
          {y, ""} ->
            y

          _ ->
            raise ArgumentError, message: "Invalid y coordinate on line #{index}"
        end

        {x, y}

      _ ->
        raise ArgumentError, message: "Invalid position on line #{index}"
    end
  end
end
