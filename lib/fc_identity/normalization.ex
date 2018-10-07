defmodule FCIdentity.Normalization do

  @doc """
  Trim all values in the struct that are string.
  """
  def trim_strings(struct) do
    Enum.reduce(Map.keys(struct), struct, fn(k, acc) ->
      v = Map.get(struct, k)

      if String.valid?(v) do
        Map.put(acc, k, String.trim(v))
      else
        acc
      end
    end)
  end
end