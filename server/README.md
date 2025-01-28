# Server

## Local development

To start your Phoenix server:

  - Make sure Elixir is correctly installed on your machine
  - `cd server`
  - Run `mix setup` to install and setup dependencies
  - Copy `.env.example` and rename it to `.env`
  - Change env variables values - `GUARDIAN_SECRET` should be changed to a different string (you can use `mix guardian.gen.secret` to get it). The same is true for `SECRET_KEY_BASE`.
  - Source .env file with `source .env`
  - Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

## Docker

  - Make sure Docker is installed on your machine
  - `cd server`
  - Set the environment variables `GUARDIAN_SECRET` and `SECRET_KEY_BASE` as explained in the previous section
  - `docker compose up -d`
  - `docker compose exec phoenix bash`
  - From the phoenix container shell launch these commands:
    - `mix ecto.migrate` - launches migrations to generate database tables
    - Create a user (necessary to login and call apis that require a valid JWT):
      - `iex -S mix`
      - `Server.Users.create_user(%{username: "me", password: "secret"})`