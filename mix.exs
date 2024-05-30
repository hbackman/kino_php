defmodule KinoPHP.MixProject do
  use Mix.Project

  def project do
    [
      app: :kino_php,
      version: "0.2.0",
      description: "Livebook SmartCell to run PHP scripts.",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {KinoPHP.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.12.2"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Hampus Backman"],
      licenses: ["MIT"],
      links: %{"GitHub": "https://github.com/hbackman/kino_php"}
    ]
  end
end
