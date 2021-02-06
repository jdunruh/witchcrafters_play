defmodule WitchcraftersPlay.MixProject do
  use Mix.Project

  def project do
    [
      app: :witchcrafters_play,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test"]

  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:witchcraft, "~> 1.0"},
      {:quark, "~> 2.3"},
      {:algae, "~> 1.2"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:stream_data, "~> 0.5", only: :test}
    ]
  end
end
