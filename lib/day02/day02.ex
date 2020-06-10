defmodule Advent2015.Day02 do
  @typedoc """
  The dimensions of a single box for which to wrap paper and a ribbon around.
  """
  @type dimensions :: {length :: number, width :: number, height :: number}

  @puzzle_input File.read!("#{__DIR__}/puzzle_input.txt")

  @doc """
  Displays the solutions of day 2.
  """
  @spec day02 :: nil
  def day02 do
    part01()
    part02()

    nil
  end

  defp part01 do
    @puzzle_input
    |> decode_dimensions()
    |> Enum.map(&calculate_wrapping_paper/1)
    |> Enum.reduce(0, &+/2)
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> decode_dimensions()
    |> Enum.map(&calculate_ribbon/1)
    |> Enum.reduce(0, &+/2)
    |> IO.inspect(label: "part02")
  end

  @doc """
  Calculates the amount of wrapping paper needed for a box from the dimensions
  of said box.

  ## Examples

      iex> calculate_wrapping_paper({2, 3, 4})
      58

      iex> calculate_wrapping_paper({1, 1, 10})
      43
  """
  @spec calculate_wrapping_paper(dimensions) :: number
  def calculate_wrapping_paper({length, width, height}) do
    side1 = length * width
    side2 = width * height
    side3 = height * length

    side1 * 2 + side2 * 2 + side3 * 2 + Enum.min([side1, side2, side3])
  end

  @doc """
  Calculates the amount of ribbons needed for a box from the dimensions of said
  box.

  ## Examples

      iex> calculate_ribbon({2, 3, 4})
      34

      iex> calculate_ribbon({1, 1, 10})
      14
  """
  @spec calculate_ribbon(dimensions) :: number
  def calculate_ribbon({length, width, height}) do
    side1 = length * 2 + width * 2
    side2 = width * 2 + height * 2
    side3 = height * 2 + length * 2

    Enum.min([side1, side2, side3]) + length * width * height
  end

  @doc """
  Decodes a string into a list of dimensions.

  ## Examples

      iex> decode_dimensions("2x3x4")
      [{2.0, 3.0, 4.0}]

      iex> decode_dimensions("1x1x10\\n2x3x4")
      [{1.0, 1.0, 10.0}, {2.0, 3.0, 4.0}]
  """
  @spec decode_dimensions(String.t) :: [dimensions]
  def decode_dimensions(dimensions) do
    dimensions
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.with_index()
    |> Enum.map(&decode_dimensions_line/1)
  end

  defp decode_dimensions_line({line, index}) do
    case String.split(line, "x", parts: 4) do
      [length, width, height] ->
        length = case Float.parse(length) do
          {length, ""} ->
            length
          _ ->
            raise ArgumentError, message: "Invalid length of box dimensions at line #{index}"
        end

        width = case Float.parse(width) do
          {width, ""} ->
            width
          _ ->
            raise ArgumentError, message: "Invalid width of box dimensions at line #{index}"
        end

        height = case Float.parse(height) do
          {height, ""} ->
            height
          _ ->
            raise ArgumentError, message: "Invalid height of box dimensions at line #{index}"
        end

        {length, width, height}
      _ ->
        raise ArgumentError, message: "Invalid box dimensions at line #{index}"
    end
  end
end
