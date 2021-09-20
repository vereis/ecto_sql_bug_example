# BugExample

If you're using `nix` or `nixos` you can just do a `nix-shell` or if using `lorri` or `direnv`: `direnv allow`

If you're using `docker` for `postgres` I supplied a `docker-compose.yml`

## Reproducing the bug:

1) `docker-compose up -d`
2) `mix ecto.migrate`
3) `iex -S mix`
4) Insert a few prerequisites into the db:
    ```elixir
    for _ <- 1..10, do: BugExample.Prerequisites.create_prerequisite()
    ```
5) Try running the cache function which breaks `Ecto.Repo.insert_all/2` in a way that seems strange:
    ```elixir
    BugExample.Prerequisites.cache_prerequisites
    10:13:55.522 [debug] QUERY ERROR db=0.0ms queue=1.4ms idle=1415.7ms
    INSERT INTO "prerequisite_caches" ("something","something_else","usually_null") (SELECT p0."something" FROM "prerequisites" AS p0) []
    ** (Postgrex.Error) ERROR 42601 (syntax_error) INSERT has more target columns than expressions

        query: INSERT INTO "prerequisite_caches" ("something","something_else","usually_null") (SELECT p0."something" FROM "prerequisites" AS p0)
        (ecto_sql 3.7.0) lib/ecto/adapters/sql.ex:756: Ecto.Adapters.SQL.raise_sql_call_error/1
        (ecto_sql 3.7.0) lib/ecto/adapters/sql.ex:663: Ecto.Adapters.SQL.insert_all/9
        (ecto 3.7.1) lib/ecto/repo/schema.ex:58: Ecto.Repo.Schema.do_insert_all/7
    ```
6) Note that `Ecto.Repo.all/2` works how I'd expect:
    ```elixir
    BugExample.Prerequisites.Prerequisite.base_query() |> BugExample.Prerequisites.PrerequisiteCache.select_cache() |> BugExample.Repo.all
    10:14:50.674 [debug] QUERY OK source="prerequisites" db=0.3ms queue=0.2ms idle=1568.4ms
    SELECT p0."something" FROM "prerequisites" AS p0 []
    [
      %{
        something: "872515e5-d0df-416a-bd86-dd3026a562f3",
        something_else: "This is a constant",
        usually_null: nil
      },
      ...
    ```

## The bug

The generated SQL for the `Ecto.Repo.insert_all` function seems to be:

```sql
INSERT INTO "prerequisite_caches" ("something","something_else","usually_null") (SELECT p0."something" FROM "prerequisites" AS p0) []
```

Which causes `insert_all` to break since we're expecting 3 columns but only selecting one. If we do a `select: %{something_else_valid: prerequisite.something_else_valud}` we see that added to the SQL `SELECT` clause as something akin to `SELECT p0."something_else_valid"` but it doesn't seem to respect `%{blah: null}` or other constants.

I'd expect the query above to be generated as:

```sql
INSERT INTO "prerequisite_caches" ("something","something_else","usually_null") (SELECT p0."something", 'constant' "This is a constant", NULL FROM "prerequisites" AS p0) []
```

Which reflects my intention when I ran `Ecto.Query.select/N` as well as the return value of `Ecto.Repo.all/2`
