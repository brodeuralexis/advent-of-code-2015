defmodule Advent2015.Day11 do
  @puzzle_input "vzbxkghb"

  @spec day11 :: nil
  def day11 do
    part01()
    part02()
    nil
  end

  defp part01 do
    @puzzle_input
    |> next_password()
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    @puzzle_input
    |> next_password()
    |> next_password()
    |> IO.inspect(label: "part02")
  end

  @doc """
  Indicates if the given password is valid.

  ## Examples

      iex> valid_password?('hijklmn')
      false

      iex> valid_password?('abbceffg')
      false

      iex> valid_password?('abbcegjk')
      false

      iex> valid_password?('abcdffaa')
      true

      iex> valid_password?('ghjaabcc')
      true
  """
  @spec valid_password?(String.t | charlist) :: boolean
  def valid_password?(password) when is_binary(password) do
    password |> to_charlist() |> valid_password?()
  end

  def valid_password?(password) do
    increasing_straight?(password) and not contains?(password, [?i, ?o, ?l]) and non_overlapping_pairs(password) >= 2
  end

  defp increasing_straight?(password) do
    0
    |> Range.new(length(password) - 2)
    |> Enum.map(&Enum.slice(password, &1, 3))
    |> Enum.any?(fn
      [a, b, c] when a + 1 == b and b + 1 == c and a >= ?a and c <= ?z ->
        true
      _ ->
        false
    end)
  end

  defp contains?(password, letters) do
    Enum.any?(password, &Enum.member?(letters, &1))
  end

  defp non_overlapping_pairs(password) do
    0
    |> Range.new(length(password) - 1)
    |> Enum.map(&Enum.slice(password, &1, 3))
    |> Enum.count(fn
      [a, a, a] -> false
      [a, a, _] -> true
      [a, a] -> true
      _ -> false
    end)
  end

  @doc """
  Returns the next valid password.

  ## Examples

      iex> next_password('abcdefgh')
      'abcdffaa'

      iex> next_password('ghijklmn')
      'ghjaabcc'
  """
  @spec next_password(String.t | charlist) :: [char]
  def next_password(password) do
    password
    |> Stream.iterate(&increment_password/1)
    |> Stream.drop(1)
    |> Stream.drop_while(&(not valid_password?(&1)))
    |> Stream.take(1)
    |> Enum.to_list()
    |> Enum.at(0)
  end

  @doc """
  Increments the given password by 1.

  ## Examples

      iex> increment_password('xx')
      'xy'

      iex> increment_password('xy')
      'xz'

      iex> increment_password('xz')
      'ya'

      iex> increment_password('ya')
      'yb'
  """
  @spec increment_password(String.t | charlist) :: [char]
  def increment_password(password) do
    password
    |> to_charlist()
    |> Enum.reverse()
    |> do_increment_password([])
    |> Enum.reverse()
  end

  defp do_increment_password([digit | rest], acc) do
    case increment_password_digit(digit) do
      :carry -> do_increment_password(rest, acc ++ [?a])
      {:ok, digit} -> acc ++ [digit | rest]
    end
  end

  defp increment_password_digit(digit) do
    cond do
      digit == ?z -> :carry
      digit < ?z -> {:ok, digit + 1}
    end
  end
end
