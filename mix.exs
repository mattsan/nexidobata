defmodule Nexidobata.MixProject do
  use Mix.Project

  def project do
    [
      app: :nexidobata,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      escript: escript(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:absinthe, "~> 1.4"},
      {:httpoison, "~> 1.4"}
    ]
  end

  defp escript do
    [
      main_module: Nexidobata.CLI
    ]
  end
end
