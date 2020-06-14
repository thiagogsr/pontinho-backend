defmodule PontinhoWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :pontinho_web

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_pontinho_web_key",
    signing_salt: "qfGVZ+SV"
  ]

  socket "/socket", PontinhoWeb.PlayerSocket,
    websocket: [check_origin: ["//localhost", "//*.pontinhonline.com.br"]],
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :pontinho_web,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options

  plug CORSPlug, origin: ["http://localhost:3000", ~r/https?.*pontinhonline\.com\.br$/]

  plug PontinhoWeb.Router

  def init(_key, config) do
    if config[:load_from_system_env] do
      port = System.get_env("PORT", "4000")

      case Integer.parse(port) do
        {_int, ""} ->
          config = put_in(config[:http][:port], port)
          {:ok, config}

        :error ->
          {:ok, config}
      end
    else
      {:ok, config}
    end
  end
end
