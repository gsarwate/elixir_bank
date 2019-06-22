defmodule ElixirOTPBankTest do
  use ExUnit.Case
  doctest ElixirOTPBank

  test "greets the world" do
    assert ElixirOTPBank.hello() == :world
  end
end
