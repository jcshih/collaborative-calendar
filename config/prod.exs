use Mix.Config

config :collaborative_calendar, CollaborativeCalendar.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [
    scheme: "https",
    host: "limitless-depths-10324.herokuapp.com",
    port: 443],
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json"

config :logger, level: :info

config :collaborative_calendar, CollaborativeCalendar.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

config :collaborative_calendar, CollaborativeCalendar.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20,
  ssl: true
