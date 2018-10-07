defmodule FCIdentity.UsernameKeeper do
  use Commanded.Event.Handler,
    name: "750e4669-c458-472a-a9a3-6b00d27ec14f"

  alias FCIdentity.UserAdded
  alias FCIdentity.SimpleStore

  def handle(%UserAdded{} = event, _metadata) do
    key = generate_key(event.username)

    case SimpleStore.put(%{key: key}, allow_overwrite: false) do
      {:ok, _} -> :ok
      {:error, :key_already_exist} -> {:error, :username_already_exist}
    end
  end

  def generate_key(username) do
    "username::#{username}"
  end
end