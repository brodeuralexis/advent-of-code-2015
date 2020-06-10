defmodule Advent2015.Day05Test do
  use ExUnit.Case, async: true

  import Advent2015.Day05

  doctest Advent2015.Day05

  @nice_tests [
    "aaa"
  ]

  @naughty_tests [
    "jchzalrnumimnmhp",
    "haegwjzuvuyypxyu",
    "dvszwmarrgswjxmb"
  ]

  describe "nice?/1" do
    for string <- @nice_tests do
      test "\"#{string}\" is nice" do
        assert nice?(unquote(string))
      end
    end

    for string <- @naughty_tests do
      test "\"#{string}\" is naughty" do
        refute nice?(unquote(string))
      end
    end
  end

  @better_nice_tests [
    "xxyxx"
  ]

  @better_naughty_tests [
    "uurcxstgmygtbstg",
    "ieodomkazucvgmuy"
  ]

  describe "better_nice?/1" do
    for string <- @better_nice_tests do
      test "\"#{string}\" is nice" do
        assert better_nice?(unquote(string))
      end
    end

    for string <- @better_naughty_tests do
      test "\"#{string}\" is naughty" do
        refute better_nice?(unquote(string))
      end
    end
  end
end
