defmodule Bank.MixProject do
  use Mix.Project

  def project do
    [
      app: :bank,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Bank.Application, []}
    ]
  end

  defp deps do
    [
      {:incident, "~> 0.6.0"}
    ]
  end
end
