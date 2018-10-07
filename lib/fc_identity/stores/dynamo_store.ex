defmodule FCIdentity.DynamoStore do
  @behaviour FCIdentity.SimpleStore

  use OK.Pipe

  alias ExAws.Dynamo

  @dynamo_table System.get_env("AWS_DYNAMO_TABLE")

  def get(primary_key, _ \\ []) do
    raw_response =
      @dynamo_table
      |> Dynamo.get_item(%{key: primary_key})
      |> ExAws.request!()

    parse_response(raw_response["Item"])
  end

  defp parse_response(nil), do: nil

  defp parse_response(item) do
    Enum.reduce(item, %{}, fn({k, value_wrap}, acc) ->
      v =
        value_wrap
        |> Map.values()
        |> Enum.at(0)

      Map.put(acc, String.to_existing_atom(k), v)
    end)
  end

  def put(record, opts \\ [])

  def put(record, allow_overwrite: false) do
    dynamo_opts = [
      condition_expression: "attribute_not_exists(#key)",
      expression_attribute_names: %{"#key" => "key"}
    ]

    @dynamo_table
    |> Dynamo.put_item(record, dynamo_opts)
    |> ExAws.request()
    |> normalize_error()
  end

  def put(record, _) do
    @dynamo_table
    |> Dynamo.put_item(record)
    |> ExAws.request!()

    {:ok, record}
  end

  defp normalize_error({:error, {"ConditionalCheckFailedException", _}}), do: {:error, :key_already_exist}
  defp normalize_error(other), do: other
end