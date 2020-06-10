defmodule Advent2015.Day07 do
  alias Advent2015.Day07.Decoder
  alias Advent2015.Day07.Circuit

  @puzzle_input File.read!("#{__DIR__}/puzzle_input.txt")

  @spec day07 :: nil
  def day07 do
    part01()
    part02()
    nil
  end

  defp part01 do
    gates = Decoder.decode_gates(@puzzle_input)

    Circuit.new()
    |> Circuit.with_gates(gates)
    |> Circuit.resolve()
    |> Circuit.sample!("a")
    |> IO.inspect(label: "part01")
  end

  defp part02 do
    gates = Decoder.decode_gates(@puzzle_input)

    Circuit.new()
    |> Circuit.with_gates(gates)
    |> Circuit.with_gate({:assign, {:lit, 16076}, {:id, "b"}})
    |> Circuit.resolve()
    |> Circuit.sample!("a")
    |> IO.inspect(label: "part02")
  end
end
