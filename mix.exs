defmodule SpatialHash.Mixfile do
  use Mix.Project

  def project do
    [app: :spatial_hash,
     version: "0.1.0",
     elixir: "~> 1.4",
     description: description,
     package: package,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger]]
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
    [ {:envelope, "~> 0.2.0"},
      {:geo, "~> 1.3"}]
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
