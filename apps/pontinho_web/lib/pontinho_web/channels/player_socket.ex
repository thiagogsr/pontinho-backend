defmodule PontinhoWeb.PlayerSocket do
  use Phoenix.Socket

  ## Channels
  channel "game:*", PontinhoWeb.GameChannel
  channel "match:*", PontinhoWeb.MatchChannel

  # Socket params are passed from the client and can
  # be used to verify and authenticate a player. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :player_id, verified_player_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"player_id" => player_id}, socket, _connect_info) do
    case Pontinho.get_player(player_id) do
      nil -> :error
      player -> {:ok, assign(socket, :player, player)}
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given player:
  #
  #     def id(socket), do: "player_socket:#{socket.assigns.player_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given player:
  #
  #     PontinhoWeb.Endpoint.broadcast("player_socket:#{player.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(socket), do: "player_socket:#{socket.assigns.player.id}"
end
