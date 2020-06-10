defmodule Advent2015.Day01 do
  @type direction :: :up | :down
  @type directions :: [direction]

  @puzzle_input File.read!("#{__DIR__}/puzzle_input.txt")

  def day01 do
    part01()
    part02()

    nil
  end

  defp part01 do
    @puzzle_input
    |> decode_directions()
    |> floor_after()
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> decode_directions()
    |> basement_at()
    |> IO.inspect(label: "part02")
  end

  @doc """
  Gets the floor after applying a sequence of directions.

  ## Examples

      iex> floor_after([:up, :up, :down, :down])
      0

      iex> floor_after([:up, :down, :up, :down])
      0
  """
  @spec floor_after(directions) :: integer
  def floor_after(directions) do
    directions
    |> Enum.reduce(0, fn
      :up, floor -> floor + 1
      :down, floor -> floor - 1
    end)
  end

  @doc """
  Returns the position in the directions at which the basement is first entered,
  or `nil` if it is never entered.

  ## Examples

      iex> basement_at([:down])
      1

      iex> basement_at([:up, :down, :up, :down, :down])
      5
  """
  @spec basement_at(directions) :: non_neg_integer | nil
  def basement_at(directions) do
    do_basement_at(directions)
  end

  @spec do_basement_at(directions, integer, non_neg_integer) :: non_neg_integer | nil
  defp do_basement_at(directions, floor \\ 0, position \\ 0)

  defp do_basement_at(_directions, -1, position) do
    position
  end

  defp do_basement_at([:up | directions], floor, position) do
    do_basement_at(directions, floor + 1, position + 1)
  end

  defp do_basement_at([:down | directions], floor, position) do
    do_basement_at(directions, floor - 1, position + 1)
  end

  defp do_basement_at([], _floor, _position) do
    nil
  end

  @doc """
  Decodes a string into a list of directions.

  ## Examples

      iex> decode_directions("(())")
      [:up, :up, :down, :down]

      iex> decode_directions(")(()")
      [:down, :up, :up, :down]
  """
  @spec decode_directions(String.t) :: directions
  def decode_directions(directions) do
    directions
    |> String.to_charlist()
    |> Enum.with_index()
    |> Enum.map(fn
      {?(, _} ->
        :up
      {?), _} ->
        :down
      {_, index} ->
        raise ArgumentError, message: "Invalid position at index #{index}"
    end)
  end
end
