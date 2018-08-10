defmodule PlugJwtJsonapiExample.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_jwt_json_api_example,
     version: "0.1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger],
     mod: {PlugJwtJsonapiExample, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 2.0"},
      {:plug, "~> 1.0"},
      {:jason, "~> 1.0"},
      {:ja_serializer, "~> 0.13.0"},
      {:logster, "~> 0.8.0"},
      {:logger_file_backend, "~> 0.0.10"},
      {:guardian, "~> 1.0"}
    ]
  end
end
