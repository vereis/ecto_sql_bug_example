defmodule BugExample.Prerequisites.PrerequisiteCache do
  use Ecto.Schema

  import Ecto.Query

  schema "prerequisite_caches" do
    field(:something, :string)
    field(:something_else, :string)
    field(:usually_null, :string)
  end

  def select_cache(query) do
    if has_named_binding?(query, :prerequisite) do
      from([prerequisite: prerequisite] in query,
        select: %{
          something: prerequisite.something,
          something_else: "This is a constant",
          usually_null: nil
        }
      )
    else
      # This branch would usually check for another entity which can be cached,
      # and this branch does set `something_else: blah.something_else, usually_null: blah.usually_null`
      raise "Not implemented"
    end
  end
end
