defmodule NotificationInator.MixProject do
  use Mix.Project

  def project do
    [
      app: :notification_inator,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:toml, "~> 0.7"},
      {:tornium, git: "https://github.com/Tornium/tornium.git", subdir: "worker"}
    ]
  end
end
