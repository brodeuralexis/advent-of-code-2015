defmodule Advent2015.Day07.Decoder do
  alias Advent2015.Day07.Circuit

  @type gate :: Circuit.gate

  @doc """
  Decodes a string containing a gate description on each line into a list of
  gate descriptions.

  ## Example

      iex> decode_gates("123 -> x\\n456 -> y\\nx AND y -> d\\nx OR y -> e\\nx LSHIFT 2 -> f\\ny RSHIFT 2 -> g\\nNOT x -> h\\nNOT y -> i")
      [
        {:assign, {:lit, 123}, {:id, "x"}},
        {:assign, {:lit, 456}, {:id, "y"}},
        {:and, {:id, "x"}, {:id, "y"}, {:id, "d"}},
        {:or, {:id, "x"}, {:id, "y"}, {:id, "e"}},
        {:left_shift, {:id, "x"}, {:lit, 2}, {:id, "f"}},
        {:right_shift, {:id, "y"}, {:lit, 2}, {:id, "g"}},
        {:not, {:id, "x"}, {:id, "h"}},
        {:not, {:id, "y"}, {:id, "i"}},
      ]
  """
  @spec decode_gates(String.t) :: [gate]
  def decode_gates(string) do
    string
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(&decode_gate(elem(&1, 0), line: elem(&1, 1)))
  end

  defp decode_gate(string, opts) do
    case String.split(string, " ", parts: 6) do
      [input, "->", output] ->
        {:assign, decode_input(input, opts), decode_output(output, opts)}

      [left, "AND", right, "->", output] ->
        {:and, decode_input(left, opts), decode_input(right, opts), decode_output(output, opts)}

      [left, "LSHIFT", right, "->", output] ->
        {:left_shift, decode_input(left, opts), decode_input(right, opts), decode_output(output, opts)}

      ["NOT", input, "->", output] ->
        {:not, decode_input(input, opts), decode_output(output, opts)}

      [left, "OR", right, "->", output] ->
        {:or, decode_input(left, opts), decode_input(right, opts), decode_output(output, opts)}

      [left, "RSHIFT", right, "->", output] ->
        {:right_shift, decode_input(left, opts), decode_input(right, opts), decode_output(output, opts)}

      _ ->
        error("Invalid operation", opts)
    end
  end

  defp decode_input(input, opts) do
    case Integer.parse(input) do
      {n, ""} ->
        {:lit, n}

      {_, _} ->
        error("Invalid input descriptor", opts)

      :error ->
        {:id, input}
    end
  end

  defp decode_output(output, opts) do
    case Integer.parse(output) do
      {_, _} ->
        error("Invalid output descriptor", opts)

      :error ->
        {:id, output}
    end
  end

  defp error(string, opts) do
    line_suffix = case Keyword.fetch(opts, :line) do
      {:ok, line} -> " at line #{line}"
      :error -> ""
    end

    raise ArgumentError, message: string <> line_suffix
  end
end
