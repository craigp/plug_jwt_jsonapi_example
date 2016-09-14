defmodule PlugJwtJsonapiExample.GuardianSerializer do
  @behaviour Guardian.Serializer

  def for_token(%{user_name: user_name}), do: {:ok, "user:#{user_name}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("user" <> user_name), do: {:ok, %{user_name: user_name}}
  def from_token(_), do: {:error, "Unknown resource type"}

end
