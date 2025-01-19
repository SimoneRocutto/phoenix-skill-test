# Server

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Copy `.env.example` and rename it to `.env`
  * Change env variables values - GUARDIAN_SECRET should be changed to a different string (you can use `mix guardian.gen.secret` to get it)
  * Source .env file with `source .env`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
