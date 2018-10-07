defmodule FCIdentity.RoleKeeper do
  use Commanded.Event.Handler,
    name: "7acce566-f170-4b36-a1da-7655f67c65f8"

  alias FCIdentity.UserAdded
  alias FCIdentity.SimpleStore

  def handle(%UserAdded{} = event, _metadata) do
    key = generate_key(event.account_id, event.user_id)
    {:ok, _} = SimpleStore.put(key, %{role: "owner"})

    :ok
  end

  def generate_key(account_id, user_id) do
    "role::#{account_id}:#{user_id}"
  end
end