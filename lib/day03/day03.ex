defmodule Advent2015.Day03 do
  @typedoc """
  The direction received by the sleasy elf on the radio.
  """
  @type direction :: :up | :down | :left | :right

  @typedoc """
  A position in a 2D grid.
  """
  @type position :: {x :: integer, y :: integer}

  @typedoc """
  The navigation result, a map of position to the number of times that position
  was visited.

  If a house was never visited, it does not appear in this map.
  """
  @type navigation :: %{ optional(position) => non_neg_integer }

  @number_of_santas 2
  @puzzle_input File.read!("#{__DIR__}/puzzle_input.txt")

  @spec day03 :: nil
  def day03 do
    part01()
    part02()
    nil
  end

  defp part01 do
    @puzzle_input
    |> decode_directions()
    |> navigate()
    |> Map.values()
    |> Enum.count()
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> decode_directions()
    |> Enum.with_index()
    |> Enum.group_by(&Integer.mod(elem(&1, 1), @number_of_santas), &elem(&1, 0))
    |> Map.values()
    |> Enum.map(&navigate/1)
    |> Enum.reduce(%{}, fn left, right ->
      Map.merge(left, right, fn _key, left, right ->
        left + right
      end)
    end)
    |> Map.values()
    |> Enum.count()
    |> IO.inspect(label: "part02")
  end

  @doc """
  Returns a map of all houses that have been visited and the number of times
  they have been visited.

  If a house was not visited, it will not have a key
  in the returned map.

  ## Examples

      iex> navigate([:right])
      %{ {0, 0} => 1, {1, 0} => 1 }

      iex> navigate([:up, :right, :down, :left])
      %{ {0, 0} => 2, {0, 1} => 1, {1, 1} => 1, {1, 0} => 1 }

      iex> navigate([:up, :down, :up, :down, :up, :down, :up, :down, :up, :down])
      %{ {0, 0} => 6, {0, 1} => 5 }
  """
  @spec navigate([direction]) :: navigation
  def navigate(directions) do
    do_navigate(directions)
  end

  defp do_navigate(directions, position \\ {0, 0}, visited \\ %{ {0, 0} => 1 })

  defp do_navigate([], _position, visited) do
    visited
  end

  defp do_navigate([:up | directions], {x, y}, visited) do
    y = y + 1

    do_navigate(directions, {x, y}, Map.update(visited, {x, y}, 1, &(&1 + 1)))
  end

  defp do_navigate([:down | directions], {x, y}, visited) do
    y = y - 1

    do_navigate(directions, {x, y}, Map.update(visited, {x, y}, 1, &(&1 + 1)))
  end

  defp do_navigate([:left | directions], {x, y}, visited) do
    x = x - 1

    do_navigate(directions, {x, y}, Map.update(visited, {x, y}, 1, &(&1 + 1)))
  end

  defp do_navigate([:right | directions], {x, y}, visited) do
    x = x + 1

    do_navigate(directions, {x, y}, Map.update(visited, {x, y}, 1, &(&1 + 1)))
  end

  @doc """
  Decodes a string into a sequence of directions.

  ## Examples

      iex> decode_directions(">")
      [:right]

      iex> decode_directions("^>v<")
      [:up, :right, :down, :left]

      iex> decode_directions("^v^v^v^v^v")
      [:up, :down, :up, :down, :up, :down, :up, :down, :up, :down]
  """
  @spec decode_directions(String.t) :: [direction]
  def decode_directions(directions) do
    directions
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.map(fn
      {?<, _} ->
        :left
      {?>, _} ->
        :right
      {?^, _} ->
        :up
      {?v, _} ->
        :down
      {direction, index} ->
        raise ArgumentError, message: "Invalid direction \"#{direction}\" at #{index}"
    end)
  end
end
