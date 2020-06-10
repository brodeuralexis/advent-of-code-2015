defmodule Advent2015.Day12 do
  @puzzle_input "#{__DIR__}/puzzle_input.txt" |> File.read!() |> Poison.decode!()

  @spec day12 :: nil
  def day12 do
    part01()
    part02()
    nil
  end

  defp part01 do
    @puzzle_input
    |> sum_all_numbers()
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> sum_all_numbers_double_counted()
    |> IO.inspect(label: "part02")
  end

  @doc """
  Sums all the numbers that are recursively present in the given document.

  ## Examples

      iex> sum_all_numbers([1, 2, 3])
      6

      iex> sum_all_numbers(%{"a" => 2, "b" => 4})
      6

      iex> sum_all_numbers([[[3]]])
      3

      iex> sum_all_numbers(%{"a" => %{"b" => 4}, "c" => -1})
      3

      iex> sum_all_numbers(%{"a" => [-1, 1]})
      0

      iex> sum_all_numbers([-1, %{"a" => 1}])
      0

      iex> sum_all_numbers([])
      0

      iex> sum_all_numbers(%{})
      0
  """
  @spec sum_all_numbers(any) :: number
  def sum_all_numbers(document) do
    do_sum_all_numbers(document, 0)
  end

  defp do_sum_all_numbers(number, sum) when is_number(number) do
    number + sum
  end

  defp do_sum_all_numbers(object, sum) when is_map(object) do
    Enum.reduce(object, sum, fn {_key, value}, sum ->
      do_sum_all_numbers(value, sum)
    end)
  end

  defp do_sum_all_numbers(array, sum) when is_list(array) do
    Enum.reduce(array, sum, fn value, sum ->
      do_sum_all_numbers(value, sum)
    end)
  end

  defp do_sum_all_numbers(_, sum) do
    sum
  end

  @doc """
  Sums all numbers that are recursively ppresent in the given document, while
  omiting any object that has a `"red"` properties, including its children.

  ## Examples

      iex> sum_all_numbers_double_counted([1, 2, 3])
      6

      iex> sum_all_numbers_double_counted([1, %{"c" => "red", "b" => 2}, 3])
      4

      iex> sum_all_numbers_double_counted(%{"d" => "red", "e" => [1, 2, 3, 4], "f" => 5})
      0

      iex> sum_all_numbers_double_counted([1, "red", 5])
      6
  """
  @spec sum_all_numbers_double_counted(any) :: number
  def sum_all_numbers_double_counted(document) do
    do_sum_all_numbers_double_counted(document, 0)
  end

  defp do_sum_all_numbers_double_counted(number, sum) when is_number(number) do
    number + sum
  end

  defp do_sum_all_numbers_double_counted(object, sum) when is_map(object) do
    if object |> Map.values() |> Enum.member?("red") do
      sum
    else
      Enum.reduce(object, sum, fn {_key, value}, sum ->
        do_sum_all_numbers_double_counted(value, sum)
      end)
    end
  end

  defp do_sum_all_numbers_double_counted(array, sum) when is_list(array) do
    Enum.reduce(array, sum, fn value, sum ->
      do_sum_all_numbers_double_counted(value, sum)
    end)
  end

  defp do_sum_all_numbers_double_counted(_, sum) do
    sum
  end
end
