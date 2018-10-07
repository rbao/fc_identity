defmodule FCIdentity.RoleKeeper do
  use Commanded.Event.Handler,
    name: "7acce566-f170-4b36-a1da-7655f67c65f8"

  alias FCIdentity.UserAdded
  alias FCIdentity.SimpleStore

  def handle(%UserAdded{} = event, _metadata), do: keep(event)

  def keep(event) do
    key = generate_key(event.account_id, event.user_id)
    {:ok, _} = SimpleStore.put(key, %{role: "owner"})

    :ok
  end

  def get(user_id, account_id) do
    key = generate_key(account_id, user_id)

    case SimpleStore.get(key) do
      %{role: role} -> role
      _ -> nil
    end
  end

  defp generate_key(account_id, user_id) do
    "role::#{account_id}:#{user_id}"
  end
end