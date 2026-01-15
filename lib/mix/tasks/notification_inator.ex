defmodule Mix.Tasks.NotificationInator.Test do
  @moduledoc """
  Mix task to run and test a Tornium notification.
  """

  use Mix.Task

  @doc false
  @impl Mix.Task
  def run([path] = _args) when is_binary(path) do
    path = Path.expand(path)

    cond do
      not File.exists?(path) ->
        Mix.raise("Path does not exist: #{path}")

      not File.dir?(path) ->
        Mix.raise("Path is not a directory: #{path}")

      true ->
        Tornium.NotificationInator.execute_notification(path)
    end
  end

  def run(_args) do
    Mix.raise("Usage: mix notification_inator PATH")
  end
end
