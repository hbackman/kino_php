defmodule KinoPHP.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_php,
      version: "0.1.0",
      description: "Livebook SmartCell to run PHP scripts.",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {KinoPHP.Application, []},
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.12.2"},
      # {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Hampus Backman"],
      licenses: ["Apache-2.0"],
      links: %{},
    ]
  end
end
