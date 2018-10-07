defmodule FCIdentity.RouterTest do
  use FCIdentity.DataCase

  alias FCIdentity.Router
  alias FCIdentity.RegisterUser
  alias FCIdentity.{UserAdded, AccountCreated, UserRegistered}

  @tag :focus
  describe "dispatch RegisterUser" do
    test "with valid command" do
      cmd = %RegisterUser{
        username: Faker.String.base64(8),
        password: Faker.String.base64(12),
        email: Faker.Internet.email(),
        is_term_accepted: true,
        name: Faker.Name.name()
      }
      :ok = Router.dispatch(cmd)

      assert_receive_event(AccountCreated, fn(event) ->
        assert event.name == "Unamed Account"
      end)

      assert_receive_event(UserAdded, fn(event) ->
        assert event.username == event.username
      end)

      assert_receive_event(UserRegistered, fn(event) ->
        assert event.username == cmd.username
      end)
    end
  end
end