defmodule ElixirBankTest do
  use ExUnit.Case
  doctest ElixirBank

  test "greets the world" do
    assert ElixirBank.hello() == :world
  end
end
