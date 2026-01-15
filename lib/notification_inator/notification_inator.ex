defmodule Tornium.NotificationInator do
  require Logger

  @type notification :: %{
          config: notification_config(),
          code: String.t(),
          message_template: Solid.Template.t(),
          test_modules: [module()]
        }

  @type notification_config :: %{
          trigger: %{
            uuid: String.t(),
            name: String.t(),
            description: String.t(),
            owner: pos_integer()
          },
          implementation: %{
            cron: String.t(),
            resource: String.t(),
            selections: [String.t()],
            message_type: notification_type(),
            parameters: %{String.t() => String.t()}
          }
        }

  @typedoc "Either \"send\" or \"update\" the message"
  @type notification_type :: String.t()

  @spec execute_notification(path :: String.t()) :: term()
  def execute_notification(path) when is_binary(path) do
    ExUnit.start(autorun: false)
    Logger.debug("ExUnit started")

    Logger.debug("Attempting to load notification at #{path}")
    notification = load_notification(path)
    Logger.info("Found and parsed notification \"#{notification.config["trigger"]["name"]}\"")

    path
    |> Path.join("test.exs")
    |> Code.require_file()

    ExUnit.configure(notification: notification)
    ExUnit.run(notification.test_modules)
  end

  @doc """
  Load a notification from its directory.
  """
  @spec load_notification(path :: String.t()) :: notification()
  def load_notification(path) when is_binary(path) do
    %{
      config: path |> Path.join("config.toml") |> File.read!() |> Toml.decode!(),
      code: path |> Path.join("code.lua") |> File.read!(),
      message_template: path |> Path.join("message.liquid") |> File.read!() |> Solid.parse!(),
      test_modules: path |> Path.join("test.exs") |> File.read!() |> get_modules()
    }
  end

  @spec get_modules(elixir_file :: String.t()) :: [module()]
  defp get_modules(elixir_file) when is_binary(elixir_file) do
    # \S is equivalent to [^\s]
    ~r{defmodule \s+ (\S+) }x
    |> Regex.scan(elixir_file, capture: :all_but_first)
    |> Enum.map(fn [name] -> String.to_atom("Elixir.#{name}") end)
  end
end
