defmodule PlugJwtJsonapiExample.Mixfile do
  use Mix.Project

  def project do
    [app: :plug_jwt_json_api_example,
     version: "0.1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :logster, :cowboy, :plug, :poison,
      :ja_serializer, :logger_file_backend],
     mod: {PlugJwtJsonapiExample, []}]
  end

  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:plug, "~> 1.1"},
      {:poison, "~> 2.2.0"},
      {:ja_serializer, "~> 0.10.1"},
      {:logster, "~> 0.3.0"},
      {:logger_file_backend, "~> 0.0.8"},
      {:guardian, "~> 0.12.0"}
    ]
  end
end
