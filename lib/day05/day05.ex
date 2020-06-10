defmodule Advent2015.Day05 do
  @puzzle_input File.read!("#{__DIR__}/puzzle_input.txt")

  @spec day05 :: nil
  def day05 do
    part01()
    part02()
    nil
  end

  defp part01 do
    @puzzle_input
    |> String.split("\n")
    |> Enum.filter(&nice?/1)
    |> length()
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> String.split("\n")
    |> Enum.filter(&better_nice?/1)
    |> length()
    |> IO.inspect(label: "part02")
  end

  @doc """
  Indicates if, according to santa, the given string is nice.

  ## Example

      iex> nice?("ugknbfddgicrmopn")
      true
  """
  @spec nice?(String.t) :: boolean
  def nice?(string) do
    list = to_charlist(string)

    number_vowels =
      list
      |> Enum.count(&vowel?/1)

    dedup_length =
      list
      |> Enum.dedup()
      |> length()

    number_vowels >= 3 and dedup_length < length(list) and not contains?(string, ["ab", "cd", "pq", "xy"])
  end

  @spec vowel?(char) :: boolean
  def vowel?(char)

  for vowel <- [?a, ?e, ?i, ?o, ?u] do
    def vowel?(unquote(vowel)), do: true
  end

  def vowel?(_), do: false

  @spec contains?(String.t, [String.t]) :: boolean
  def contains?(string, patterns) do
    Enum.reduce_while(patterns, false, fn pattern, _ ->
      if String.contains?(string, pattern) do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  @doc """
  Indicates if, according to Santa's new algorithm, the given string is nice.

  ## Example

      iex> better_nice?("qjhvhtzxzqqjkmpb")
      true
  """
  @spec better_nice?(String.t) :: boolean
  def better_nice?(string) do
    letter_repeats_with_one_letter_between(string) and group_repeats?(string)
  end

  defp letter_repeats_with_one_letter_between(string) do
    0
    |> Range.new(String.length(string))
    |> Enum.map(&String.slice(string, &1, 3))
    |> Enum.map(&to_charlist/1)
    |> Enum.any?(fn
      [a, a, a] -> false
      [a, _, a] -> true
      _ -> false
    end)
  end

  defp group_repeats?(string) do
    len = String.length(string)

    if len < 4 do
      false
    else
      0
      |> Range.new(String.length(string) - 2)
      |> Enum.map(&String.slice(string, &1, 2))
      |> Enum.any?(fn group ->
        string |> String.replace(group, "") |> String.length() < len - String.length(group)
      end)
    end
  end
end
