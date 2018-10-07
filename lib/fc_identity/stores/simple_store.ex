defmodule FCIdentity.SimpleStore do
  @store Application.get_env(:fc_identity, __MODULE__)

  @callback get(record :: map, opts :: keyword) :: any
  @callback put(primary_key :: String.t(), opts :: keyword) :: {:ok, any} | {:error, any}

  defdelegate get(record, opts \\ []), to: @store
  defdelegate put(primary_key, opts \\ []), to: @store
end