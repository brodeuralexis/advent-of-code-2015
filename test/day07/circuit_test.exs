defmodule Advent2015.Day07.CircuitTest do
  use ExUnit.Case, async: true

  alias Advent2015.Day07.Circuit
  alias Advent2015.Day07.Decoder

  doctest Circuit

  test "a simple circuit has the right state" do
    gates = Decoder.decode_gates("123 -> x\n456 -> y\nx AND y -> d\nx OR y -> e\nx LSHIFT 2 -> f\ny RSHIFT 2 -> g\nNOT x -> h\nNOT y -> i")

    circuit = Circuit.new() |> Circuit.with_gates(gates) |> Circuit.resolve()

    assert Circuit.sample!(circuit) == %{
      "d" => 72,
      "e" => 507,
      "f" => 492,
      "g" => 114,
      "h" => 65412,
      "i" => 65079,
      "x" => 123,
      "y" => 456
    }
  end
end
