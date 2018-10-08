defmodule FCIdentity.Support do
  def unwrap_ok({:ok, result}), do: result
  def unwrap_ok(other), do: other

  def struct_merge(dest, src, keys \\ nil) do
    keys = keys || Map.keys(dest) -- [:__struct__]
    filtered_src = Map.take(src, keys)
    struct(dest, filtered_src)
  end
end