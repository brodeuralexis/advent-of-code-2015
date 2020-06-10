defmodule Advent2015.Day08 do
  @puzzle_input File.read!("#{__DIR__}/puzzle_input.txt")

  @spec day08 :: nil
  def day08 do
    part01()
    part02()
    nil
  end

  defp part01 do
    strings =
      @puzzle_input
      |> String.split("\n")
      |> Enum.map(&String.trim/1)

    strings_total_length =
      strings
      |> Enum.map(&String.length/1)
      |> Enum.sum()

    escaped_strings_total_length =
      strings
      |> Enum.map(&escape/1)
      |> Enum.map(&String.length/1)
      |> Enum.sum()

      IO.inspect(strings_total_length - escaped_strings_total_length, label: "part01")
  end

  defp part02 do
    strings =
      @puzzle_input
      |> String.split("\n")
      |> Enum.map(&String.trim/1)

    strings_total_length =
      strings
      |> Enum.map(&String.length/1)
      |> Enum.sum()

    unescaped_strings_total_length =
      strings
      |> Enum.map(&unescape/1)
      |> Enum.map(&String.length/1)
      |> Enum.sum()

    IO.inspect(unescaped_strings_total_length - strings_total_length, label: "part02")
  end

  @doc """
  Escapes a string on Santa's digital copy.

  ## Examples

      iex> escape("\\"\\"")
      ""

      iex> escape("\\"abc\\"")
      "abc"

      iex> escape("\\"aaa\\\\\\"aa\\"")
      "aaa\\"aa"

      iex> escape("\\"\\x27\\"")
      "'"
  """
  @spec escape(String.t) :: String.t
  def escape(string) do
    do_escape(string, "", string)
  end

  defp do_escape("\"", escaped_string, _string) do
    escaped_string
  end

  defp do_escape("\"" <> rest, "", string) do
    do_escape(rest, "", string)
  end

  defp do_escape(<< "\\\\" :: utf8, rest :: binary >>, escaped_string, string) do
    do_escape(rest, escaped_string <> "\\" ,string)
  end

  defp do_escape(<< "\\\"" :: utf8, rest :: binary >>, escaped_string, string) do
    do_escape(rest, escaped_string <> "\"", string)
  end

  defp do_escape(<< "\\x" :: utf8, char :: 16, rest :: binary >>, escaped_string, string) do
    do_escape(rest, escaped_string <> to_string([char]), string)
  end

  defp do_escape(<< "\"" :: utf8, _ :: binary >>, _, string) do
    raise ArgumentError, message: "Unexpected unescaped ?\" in #{string}"
  end

  defp do_escape(<< "\\" :: utf8, _ :: binary >>, _, string) do
    raise ArgumentError, message: "Unexpected unescaped ?\\ in #{string}"
  end

  defp do_escape(<< byte :: 8, rest :: binary >>, escaped_string, string) do
    do_escape(rest, escaped_string <> to_string([byte]), string)
  end

  @doc """
  Unescapes a string on Santa's digital copy.

  ## Examples

      iex> unescape("")
      "\\"\\""

      iex> unescape("abc")
      "\\"abc\\""

      iex> unescape("aaa\\\"aaa")
      "\\"aaa\\\\\\\"aaa\\""

      iex> unescape("\\\\x27")
      "\\"\\\\\\\\x27\\""
  """
  @spec unescape(String.t) :: String.t
  def unescape(string) do
    "\"#{do_unescape(string, "", string)}\""
  end

  defp do_unescape(<<>>, unescaped_string, _string) do
    unescaped_string
  end

  defp do_unescape(<< "\"" :: utf8, rest :: binary >>, unescaped_string, string) do
    do_unescape(rest, unescaped_string <> "\\\"", string)
  end

  defp do_unescape(<< "\\" :: utf8, rest :: binary >>, unescaped_string, string) do
    do_unescape(rest, unescaped_string <> "\\\\", string)
  end

  defp do_unescape(<< byte :: 8, rest :: binary >>, unescaped_string, string) do
    do_unescape(rest, unescaped_string <> to_string([byte]), string)
  end
end
