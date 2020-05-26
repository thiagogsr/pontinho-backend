import Config

config :pontinho_web, PontinhoWeb.Endpoint, secret_key_base: System.fetch_env!("SECRET_KEY_BASE")
