defmodule Server.Users.VerifyPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :server,
    error_handler: Server.Users.VerifyErrorHandler,
    module: Server.Guardian

  # # If there is a session token, restrict it to an access token and validate it
  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}
  # If there is an authorization header, restrict it to an access token and validate it
  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
end
