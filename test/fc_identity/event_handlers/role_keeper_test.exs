defmodule FCIdentity.RoleKeeperTest do
  use FCIdentity.DataCase

  alias FCIdentity.RoleKeeper
  alias FCIdentity.SimpleStore
  alias FCIdentity.UserAdded

  test "handle UserAdded" do
    event = %UserAdded{user_id: uuid4(), account_id: uuid4()}

    :ok = RoleKeeper.handle(event, %{})

    key = RoleKeeper.generate_key(event.account_id, event.user_id)
    %{role: "owner"} = SimpleStore.get(key)
  end
end