defmodule BugExampleTest do
  use ExUnit.Case

  import Ecto.Query

  test "I expect this to not crash!" do
    # The following assertions work
    assert 0 = BugExample.Repo.one(from x in BugExample.Schema, select: count(x))
    assert {0, "hello"} = BugExample.Repo.one(from x in BugExample.Schema, select: {count(x), "hello"})
    assert {0, 123} = BugExample.Repo.one(from x in BugExample.Schema, select: {count(x), 123})

    expectation = "hello"
    assert {0, ^expectation} = BugExample.Repo.one(from x in BugExample.Schema, select: {count(x), ^expectation})

    # This crashes... :-(
    expectation = 123
    assert {0, ^expectation} = BugExample.Repo.one(from x in BugExample.Schema, select: {count(x), ^expectation})
  end
end
