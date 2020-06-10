defmodule Advent2015.Day04 do
  @puzzle_input "ckczppom"

  @spec day04 :: nil
  def day04 do
    part01()
    part02()
    nil
  end

  defp part01 do
    @puzzle_input
    |> mine()
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> mine(leading_zeroes: 6)
    |> IO.inspect(label: "part02")
  end

  @typedoc """
  The options that can be given to the `mine/2` function.
  """
  @type mine_opt :: {:from, non_neg_integer}
                  | {:to, non_neg_integer}
                  | {:leading_zeroes, 5 | 6}

  @doc """
  Crypto mines the given secret until it starts with 5 hexadecimal zeroes, or
  the number specified by the `:leading_zeroes` option.

  If the secret is not in the range between `:from` and `:to`, `nil` is
  returned.

  If no range is given, the function could run for a very long time.

  ## Options

    - `:from` dictates the starting value of the cryptomining operation.
    - `:to` dictates the ending value of the  cryptomining operation.
    - `:leading_zeroes` controls the amount of leading zeroes for which to check
      the hash digest with.

  ## Examples

      iex> mine("abcdef", to: 700_000)
      609_043

      iex> mine("pqrstuv", to: 1_100_000)
      1_048_970
  """
  @spec mine(String.t, [mine_opt]) :: non_neg_integer | nil
  def mine(secret_key, opts \\ []) do
    from = Keyword.get(opts, :from, 0)
    to = Keyword.get(opts, :to, nil)
    leading_zeroes = Keyword.get(opts, :leading_zeroes, 5)

    do_mine(secret_key, from, to, leading_zeroes)
  end

  for leading <- 5..6 do
    defp do_mine(secret_key, from, to, unquote(leading)) do
      case :crypto.hash(:md5, "#{secret_key}#{from}") do
        << 0 :: 4 * unquote(leading), _ :: bitstring >> ->
          from
        _ when to != nil and from >= to ->
          nil
        _ ->
          do_mine(secret_key, from + 1, to, unquote(leading))
      end
    end
  end
end
