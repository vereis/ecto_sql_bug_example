defmodule BugExample.Prerequisites.Prerequisite do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  schema "prerequisites" do
    field(:something, :string)
  end

  def changeset(%__MODULE__{} = entity, attrs) do
    entity
    |> cast(attrs, [:something])
  end

  def base_query do
    from(p in __MODULE__, as: :prerequisite)
  end
end
