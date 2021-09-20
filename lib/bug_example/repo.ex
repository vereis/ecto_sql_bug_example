defmodule BugExample.Repo do
  use Ecto.Repo,
    otp_app: :bug_example,
    adapter: Ecto.Adapters.Postgres
end
