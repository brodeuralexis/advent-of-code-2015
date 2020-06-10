defmodule Advent2015.Day10 do
  @puzzle_input 3113322113

  @spec day10 :: nil
  def day10 do
    part01()
    part02()
    nil
  end

  defp part01 do
    @puzzle_input
    |> Stream.iterate(&look_and_say/1)
    |> Stream.drop(40)
    |> Stream.take(1)
    |> Enum.to_list()
    |> Enum.map(&length/1)
    |> Enum.at(0)
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> Stream.iterate(&look_and_say/1)
    |> Stream.drop(50)
    |> Stream.take(1)
    |> Enum.to_list()
    |> Enum.map(&length/1)
    |> Enum.at(0)
    |> IO.inspect(label: "part02")
  end

  @doc """
  Implementation of the look and say algorithm.

  ## Examples

      iex> look_and_say('1')
      '11'

      iex> look_and_say('11')
      '21'

      iex> look_and_say('21')
      '1211'

      iex> look_and_say('1211')
      '111221'

      iex> look_and_say('111221')
      '312211'
  """
  @spec look_and_say(charlist) :: charlist
  @spec look_and_say(String.t) :: charlist
  @spec look_and_say(integer) :: charlist
  def look_and_say(n) do
    n
    |> to_charlist()
    |> Enum.chunk_by(&(&1))
    |> Enum.map(fn [digit | _] = group ->
      Enum.concat(group |> length() |> to_charlist(), [digit])
    end)
    |> Enum.concat()
  end
end
