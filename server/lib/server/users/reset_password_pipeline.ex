defmodule Server.Users.ResetPasswordPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :server,
    error_handler: Server.Users.ErrorHandler,
    module: Server.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "reset"}
  plug Guardian.Plug.LoadResource
end
