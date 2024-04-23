import Config

# -------- #
# Database #
# -------- #
database = System.get_env("PG_DATABASE", "peapescarte")
db_user = System.get_env("DATABASE_USER", "peapescarte")
db_pass = System.get_env("DATABASE_PASSWORD", "peapescarte")
db_port = System.get_env("DATABASE_PORT", "5432")
# docker-compose service
hostname = System.get_env("DATABASE_HOST", "localhost")

database_opts = [
  username: db_user,
  password: db_pass,
  hostname: hostname,
  database: database,
  port: String.to_integer(db_port),
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
]

config :pescarte, Pescarte.Database.Repo, database_opts
config :pescarte, Pescarte.Database.Repo.Replica, database_opts

config :pescarte, PescarteWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  reloadable_compilers: [:elixir],
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]},
    sass: {DartSass, :install_and_run, [:default, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"storybook/.*(exs)$",
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/pescarte_web/design_system.ex$",
      ~r"lib/pescarte_web/(controllers|layouts|live|design_system|components|templates)/.*(ex|heex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
