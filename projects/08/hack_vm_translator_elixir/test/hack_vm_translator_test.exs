defmodule HackVmTranslatorTest do
  use ExUnit.Case
  doctest HackVmTranslator

  test "greets the world" do
    assert HackVmTranslator.hello() == :world
  end
end
