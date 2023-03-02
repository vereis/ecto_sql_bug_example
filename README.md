# BugExample

If you're using `nix` or `nixos` you can just do a `nix-shell` or if using `lorri` or `direnv`: `direnv allow`

If you're using `docker` for `postgres` I supplied a `docker-compose.yml`

## Reproducing the bug:

1) `docker-compose up -d`
2) `MIX_ENV=test mix do ecto.drop, ecto.create, ecto.migrate`
3) `mix test`

It looks like `Repo.select(from x in Schema, select: %{something: ^result})` when `result = 123` will cause an error as follows:

```elixir
  1) test I expect this to not crash! (BugExampleTest)
     test/bug_example_test.exs:6
     ** (DBConnection.EncodeError) Postgrex expected a binary, got 123. Please make sure the value you are passing matches the definition in your table or in your query or convert the value accordingly.
     code: assert {0, ^expectation} = BugExample.Repo.one(from x in BugExample.Schema, select: {count(x), ^expectation})
     stacktrace:
       (postgrex 0.16.5) lib/postgrex/type_module.ex:947: Postgrex.DefaultTypes.encode_params/3
       (postgrex 0.16.5) lib/postgrex/query.ex:75: DBConnection.Query.Postgrex.Query.encode/3
       (db_connection 2.4.3) lib/db_connection.ex:1304: DBConnection.encode/5
       (db_connection 2.4.3) lib/db_connection.ex:1404: DBConnection.run_prepare_execute/5
       (db_connection 2.4.3) lib/db_connection.ex:1508: DBConnection.run/6
       (db_connection 2.4.3) lib/db_connection.ex:644: DBConnection.parsed_prepare_execute/5
       (db_connection 2.4.3) lib/db_connection.ex:697: DBConnection.execute/4
       (ecto_sql 3.9.2) lib/ecto/adapters/postgres/connection.ex:102: Ecto.Adapters.Postgres.Connection.execute/4
       (ecto_sql 3.9.2) lib/ecto/adapters/sql.ex:858: Ecto.Adapters.SQL.execute!/5
       (ecto_sql 3.9.2) lib/ecto/adapters/sql.ex:828: Ecto.Adapters.SQL.execute/6
       (ecto 3.9.4) lib/ecto/repo/queryable.ex:229: Ecto.Repo.Queryable.execute/4
       (ecto 3.9.4) lib/ecto/repo/queryable.ex:19: Ecto.Repo.Queryable.all/3
       (ecto 3.9.4) lib/ecto/repo/queryable.ex:151: Ecto.Repo.Queryable.one/3
       test/bug_example_test.exs:17: (test)
```

Whereas doing `Repo.select(from x in Schema, select: %{something: 123})` works as one would expect.
