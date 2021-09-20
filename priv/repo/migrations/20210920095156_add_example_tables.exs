defmodule BugExample.Repo.Migrations.AddExampleTables do
  use Ecto.Migration

  def change do
    create table(:prerequisite_caches) do
      add(:something, :string)
      add(:something_else, :string)
      add(:usually_null, :string)
    end

    create table(:prerequisites) do
      add(:something, :string)
    end
  end
end
