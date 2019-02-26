defmodule SpatialHash.Mixfile do
  use Mix.Project

  def project do
    [app: :spatial_hash,
     version: "0.1.6",
     elixir: "~> 1.4",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [coveralls: :test],
     dialyzer: [plt_add_apps: [:poison, :mix]],
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :envelope]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:envelope, "~> 1.2"},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:excoveralls, "~> 0.4", only: :test},
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.4", only: [:dev], runtime: false}]
  end

  defp description do
    """
    A library for calculating spatial hashes for points and geometries.
    """
  end

  defp package do
    [
      files: ["lib/spatial_hash.ex", "mix.exs", "README*"],
      maintainers: ["Powell Kinney"],
      licenses: ["MIT"],
      links: %{ "GitHub" => "https://github.com/pkinney/spatial_hash_ex"}
    ]
  end
end
