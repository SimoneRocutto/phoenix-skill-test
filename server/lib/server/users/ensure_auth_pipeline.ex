defmodule Server.Users.EnsureAuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :server,
    error_handler: Server.Users.ErrorHandler,
    module: Server.Guardian

  plug Server.Users.AuthPipeline
  plug Guardian.Plug.EnsureAuthenticated
end
