defmodule Advent2015.Day09.Decoder do
  @type link :: {from :: String.t, to :: String.t, weight :: non_neg_integer}

  @doc """
  Decodes a string into a list of links between cities.

  ## Example

      iex> decode_links("London to Dublin = 464\\nLondon to Belfast = 518\\nDublin to Belfast = 141")
      [
        {"London", "Dublin", 464},
        {"London", "Belfast", 518},
        {"Dublin", "Belfast", 141},
      ]
  """
  @spec decode_links(String.t) :: [link]
  def decode_links(string) do
    string
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.with_index()
    |> Enum.map(&decode_link(elem(&1, 0), line: elem(&1, 1)))
  end

  defp decode_link(string, opts) do
    case String.split(string, " ", parts: 6) do
      [first, "to", second, "=", weight] ->
        {first, second, decode_weight(weight, opts)}

      _ ->
        error("Invalid link between cities", opts)
    end
  end

  defp decode_weight(weight, opts) do
    case Integer.parse(weight) do
      {weight, ""} ->
        weight

      _ ->
        error("Invalid weight", opts)
    end
  end

  defp error(message, opts) do
    line_suffix = case Keyword.fetch(opts, :line) do
      {:ok, line} -> " at line #{line}"
      :error -> ""
    end

    raise ArgumentError, message: message <> line_suffix
  end
end
