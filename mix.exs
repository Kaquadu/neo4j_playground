defmodule Neo4jPlayground.MixProject do
  use Mix.Project

  def project do
    [
      app: :neo4j_playground,
      version: "0.1.0",
      elixir: "~> 1.13",
      config_path: "./config/config.exs",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Neo4jPlayground.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.8"},
      {:bolt_sips, "~> 2.0"}
    ]
  end
end
