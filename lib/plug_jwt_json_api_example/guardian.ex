defmodule PlugJwtJsonapiExample.Guardian do

  use Guardian, otp_app: :plug_jwt_json_api_example

  def subject_for_token(%{user_name: user_name}, _clains) do
    {:ok, "user:#{user_name}"}
  end

  def subject_for_token(_, _), do: {:error, :unknown_resource}

  def resource_from_claims(%{"sub" => "user:" <> user_name}) do
    {:ok, %{user_name: user_name}}
  end

  def resource_from_claims(_), do: {:error, :unknown_claims}

end
