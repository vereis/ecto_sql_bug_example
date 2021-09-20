defmodule BugExampleTest do
  use ExUnit.Case
  doctest BugExample

  test "greets the world" do
    assert BugExample.hello() == :world
  end
end
