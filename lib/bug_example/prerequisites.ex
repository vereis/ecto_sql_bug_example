defmodule BugExample.Prerequisites do
  alias BugExample.Repo
  alias BugExample.Prerequisites.{Prerequisite, PrerequisiteCache}

  def create_prerequisite do
    %Prerequisite{}
    |> Prerequisite.changeset(%{something: Ecto.UUID.generate()})
    |> Repo.insert()
  end

  def cache_prerequisites do
    Repo.insert_all(
      PrerequisiteCache,
      Prerequisite.base_query() |> PrerequisiteCache.select_cache()
    )
  end
end
