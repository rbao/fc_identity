defmodule FCIdentity.UsernameKeeperTest do
  use FCIdentity.DataCase

  alias FCIdentity.UsernameKeeper
  alias FCIdentity.SimpleStore
  alias FCIdentity.UserAdded

  test "handle UserAdded when everything is ok" do
    event = %UserAdded{
      user_id: uuid4(),
      account_id: uuid4(),
      username: Faker.String.base64(12)
    }

    :ok = UsernameKeeper.handle(event, %{})

    assert UsernameKeeper.exist?(event.username)
  end

  test "handle UserAdded when username already exist" do
    existing_username = String.downcase(Faker.String.base64(12))
    key = UsernameKeeper.generate_key(existing_username)
    SimpleStore.put(key, %{})

    event = %UserAdded{
      user_id: uuid4(),
      account_id: uuid4(),
      username: existing_username
    }

    {:error, :username_already_exist} = UsernameKeeper.handle(event, %{})
  end
end