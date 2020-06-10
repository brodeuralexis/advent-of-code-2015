defmodule Advent2015.Day07.Circuit do
  @moduledoc """
  An electronical circuit where many gates can be connected to one another.
  """

  use Bitwise

  @typedoc """
  A literal value.
  """
  @type lit :: {:lit, non_neg_integer}

  @typedoc """
  An identifier pointing to another signal.
  """
  @type id :: {:id, String.t}

  @typedoc """
  An input of a gate is either a literal value, or the identifier of another
  signal.
  """
  @type input :: lit
               | id

  @typedoc """
  An output of a gate is simply the identifier of the signal to which to output.
  """
  @type output :: id

  @typedoc """
  The available types of gates that can be applied to a circuit.
  """
  @type gate :: {:assign, input, output}
              | {:and, input, input, output}
              | {:left_shift, input, input, output}
              | {:not, input, output}
              | {:or, input, input, output}
              | {:right_shift, input, input, output}

  @typep signal :: {:lit, non_neg_integer}
                 | {:and, input, input}
                 | {:left_shift, input, input}
                 | {:not, input}
                 | {:or, input, input}
                 | {:right_shift, input, input}

  @typedoc """
  The type of a circuit.
  """
  @opaque t :: %{ optional(String.t) => signal }

  @doc """
  Creates a new circuit without any associated gates.

  ## Examples

      iex> Circuit.new()
      %{}
  """
  @spec new :: t
  def new do
    %{}
  end

  @doc """
  Associates the given list of gates to this circuit.
  """
  @spec with_gates(t, [gate]) :: t
  def with_gates(circuit, gates) when is_list(gates) do
    Enum.reduce(gates, circuit, fn gate, circuit ->
      with_gate(circuit, gate)
    end)
  end

  @doc """
  Associates the given gate to this circuit.
  """
  @spec with_gate(t, gate) :: t
  def with_gate(circuit, gate)

  def with_gate(circuit, {:assign, input, {:id, signal}}) do
    Map.put(circuit, signal, input)
  end

  def with_gate(circuit, {:and, left, right, {:id, signal}}) do
    Map.put(circuit, signal, {:and, left, right})
  end

  def with_gate(circuit, {:left_shift, left, right, {:id, signal}}) do
    Map.put(circuit, signal, {:left_shift, left, right})
  end

  def with_gate(circuit, {:not, input, {:id, signal}}) do
    Map.put(circuit, signal, {:not, input})
  end

  def with_gate(circuit, {:or, left, right, {:id, signal}}) do
    Map.put(circuit, signal, {:or, left, right})
  end

  def with_gate(circuit, {:right_shift, left, right, {:id, signal}}) do
    Map.put(circuit, signal, {:right_shift, left, right})
  end

  @doc """
  Returns a map sampling all the signals.
  """
  @spec sample(t) :: {:ok, %{optional(String.t) => non_neg_integer}} | {:error, any}
  def sample(circuit) do
    Enum.reduce_while(circuit, {:ok, %{}}, fn
      {signal, {:lit, value}}, {:ok, signals} ->
        {:cont, {:ok, Map.put(signals, signal, value)}}

      {signal, _}, {:ok, _} ->
        {:halt, {:error, {:unresolved, signal}}}
    end)
  end

  @doc """
  Returns a map sampling all the signals.
  """
  @spec sample!(t) :: %{optional(String.t) => non_neg_integer}
  def sample!(circuit) do
    case sample(circuit) do
      {:ok, samples} -> samples
      {:error, reason} -> raise ArgumentError, message: "Could not sample signals: #{reason}"
    end
  end

  @doc """
  Returns the literal value associated with the given signal.
  """
  @spec sample(t, String.t) :: {:ok, non_neg_integer} | {:error, any}
  def sample(circuit, signal) do
    case Map.fetch(circuit, signal) do
      {:ok, {:lit, n}} -> {:ok, n}
      {:ok, _} -> {:error, :unresolved}
      :error -> {:error, :unknown}
    end
  end

  @doc """
  Returns the literal value associated with the given signal.
  """
  @spec sample!(t, String.t) :: non_neg_integer
  def sample!(circuit, signal) do
    case sample(circuit, signal) do
      {:ok, value} -> value
      {:error, reason} -> raise ArgumentError, message: "The \"#{signal}\" signal is #{reason}"
    end
  end

  @spec resolve(t) :: t
  def resolve(circuit) do
    if resolved?(circuit) do
      circuit
    else
      circuit
      |> simplify()
      |> resolve()
    end
  end

  @spec resolved?(t) :: boolean
  def resolved?(circuit) do
    Enum.all?(circuit, fn
      {_signal, {:lit, _value}} -> true
      {_signal, _} -> false
    end)
  end

  defp simplify(circuit) do
    circuit
    |> apply_substitution()
    |> apply_resolution()
  end

  defp apply_substitution(circuit) do
    Enum.reduce(circuit, circuit, fn
      {signal, {:lit, value}}, circuit ->
        substitute(circuit, {:id, signal}, {:lit, value})
      _, circuit ->
        circuit
    end)
  end

  defp substitute(circuit, from, to) do
    circuit
    |> Enum.map(fn
      {signal, {binary_operation, ^from, ^from}} ->
        {signal, {binary_operation, to, to}}
      {signal, {binary_operation, ^from, right}} ->
        {signal, {binary_operation, to, right}}
      {signal, {binary_operation, left, ^from}} ->
        {signal, {binary_operation, left, to}}

      {signal, {unary_operation, ^from}} ->
        {signal, {unary_operation, to}}

      {signal, ^from} ->
        {signal, to}

      {signal, value} ->
        {signal, value}
    end)
    |> Enum.into(%{})
  end

  defp apply_resolution(circuit) do
    circuit
    |> Enum.map(fn {signal, value} ->
      {signal, eval(value)}
    end)
    |> Enum.into(%{})
  end

  defp lit(n) do
    {:lit, Integer.mod(n, 65535)}
  end

  defp eval({:and, {:lit, left}, {:lit, right}}) do
    lit(left &&& right)
  end

  defp eval({:left_shift, {:lit, left}, {:lit, right}}) do
    lit(left <<< right)
  end

  defp eval({:not, {:lit, value}}) do
    lit(~~~(value - 1))
  end

  defp eval({:or, {:lit, left}, {:lit, right}}) do
    lit(left ||| right)
  end

  defp eval({:right_shift, {:lit, left}, {:lit, right}}) do
    lit(left >>> right)
  end

  defp eval(value) do
    value
  end
end
