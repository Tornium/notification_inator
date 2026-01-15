defmodule Tornium.NotificationInator.API do
  @moduledoc """
  Patched Lua API to inject into the Lua VM.
  """

  use Lua.API, scope: "tornium"

  deflua get_discord_id(user_id) do
    # This is a patched implementation of get_discord_id/1 found in Tornium.Notifictaion.Lua.API to
    # remove the dependency upon the Tornium.User.DiscordStore cache and the PostgreSQL database.

    case user_id do
      _ when is_integer(user_id) ->
        # TODO: Implement this using tornex
        nil

      _ when is_number(user_id) or is_float(user_id) ->
        user_id
        |> trunc()
        |> get_discord_id()

      _ when is_binary(user_id) ->
        {parsed_user_id, _binary_rest} = Float.parse(user_id)

        parsed_user_id
        |> trunc()
        |> get_discord_id()
    end
  end

  deflua to_boolean(value), do: Tornium.Notification.Lua.API.to_boolean(value)
end
