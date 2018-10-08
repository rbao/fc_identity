defmodule FCIdentity.Support do
  def unwrap_ok({:ok, result}), do: result
  def unwrap_ok(other), do: other

  def struct_merge(dest, src, keys \\ nil) do
    keys = keys || Map.keys(dest) -- [:__struct__]
    filtered_src = Map.take(src, keys)
    struct(dest, filtered_src)
  end

  # Generate uuid for keys of struct ends in `id_`
  def generate_ids(struct, keys \\ nil) do
    keys = keys || Enum.filter(Map.keys(struct), fn(key) ->
      sk = Atom.to_string(key)
      String.ends_with?(sk, "id")
    end)

    Enum.reduce(keys, struct, fn(k, acc) ->
      if is_nil(Map.get(struct, k)) do
        Map.put(acc, k, UUID.uuid4())
      else
        acc
      end
    end)
  end
end