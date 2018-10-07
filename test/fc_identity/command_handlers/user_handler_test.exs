defmodule FCIdentity.UserHandlerTest do
  use FCIdentity.DataCase

  alias FCIdentity.UserHandler
  alias FCIdentity.UserAdded
  alias FCIdentity.AddUser
  alias FCIdentity.User

  describe "handle AddUser" do
    test "when none of first name, last name or name is given should return validation error" do
      cmd = %AddUser{}
      {:error, {:validation_failed, errors}} = UserHandler.handle(%User{}, cmd)

      assert has_error(errors, :name, :required)
    end

    test "when first name is given should return event" do
      cmd = %AddUser{first_name: Faker.Name.first_name()}
      %UserAdded{name: name} = UserHandler.handle(%User{}, cmd)
      assert name == cmd.first_name
    end

    test "when last name is given should return event" do
      cmd = %AddUser{last_name: Faker.Name.last_name()}
      %UserAdded{name: name} = UserHandler.handle(%User{}, cmd)
      assert name == cmd.last_name
    end

    test "when name is given should return event" do
      cmd = %AddUser{name: Faker.Name.name()}
      %UserAdded{name: name} = UserHandler.handle(%User{}, cmd)
      assert name == cmd.name
    end

    test "when string with extra leading and trailing space given" do
      cmd = %AddUser{name: "  roy      "}
      %UserAdded{name: name} = UserHandler.handle(%User{}, cmd)
      assert name == "roy"
    end

    test "when no password given password_hash should be nil" do
      cmd = %AddUser{name: Faker.Name.name()}
      %UserAdded{password_hash: password_hash} = UserHandler.handle(%User{}, cmd)
      assert is_nil(password_hash)
    end

    test "when password given password_hash should be populated" do
      cmd = %AddUser{name: Faker.Name.name(), password: Faker.Lorem.sentence(1)}
      %UserAdded{password_hash: password_hash} = UserHandler.handle(%User{}, cmd)
      assert password_hash
    end

    test "when all fields are valid" do
      cmd = %AddUser{
        user_id: uuid4(),
        account_id: uuid4(),
        username: Faker.String.base64(8),
        email: Faker.Internet.email(),
        name: Faker.Name.name(),
        password: Faker.Lorem.sentence(1)
      }

      event = %UserAdded{} = UserHandler.handle(%User{}, cmd)

      assert event.user_id == cmd.user_id
      assert event.account_id == cmd.account_id
      assert event.username == cmd.username
      assert event.email == cmd.email
    end
  end
end