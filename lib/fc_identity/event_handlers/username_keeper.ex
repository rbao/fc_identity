defmodule FCIdentity.UsernameKeeper do
  use Commanded.Event.Handler,
    name: "750e4669-c458-472a-a9a3-6b00d27ec14f"

  alias FCIdentity.UserAdded
  alias FCIdentity.SimpleStore

  def handle(%UserAdded{} = event, _metadata), do: keep(event)

  def keep(event) do
    key = generate_key(event)

    case SimpleStore.put(key, %{}, allow_overwrite: false) do
      {:ok, _} -> :ok
      {:error, :key_already_exist} -> {:error, :username_already_exist}
    end
  end

  def exist?(username) do
    generate_key(%{type: "standard", username: username})
    |> do_exist?()
  end

  def exist?(username, account_id) do
    generate_key(%{type: "managed", account_id: account_id, username: username})
    |> do_exist?()
  end

  defp do_exist?(key) do
    case SimpleStore.get(key) do
      nil -> false
      _ -> true
    end
  end

  defp generate_key(%{type: "standard", username: username}) do
    "username::#{username}"
  end

  defp generate_key(%{type: "managed", account_id: account_id, username: username}) do
    "username::#{account_id}:#{username}"
  end
end