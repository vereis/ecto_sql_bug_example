{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.elixir_1_11
    pkgs.inotify-tools
    pkgs.dbeaver
  ];

  shellHook = ''
    unset ERL_LIBS

    export DB_PORT="1234"
    export DB_NAME="test"
    export DB_USER="postgres"
    export DB_PASSWORD="postgres"
  '';
}
