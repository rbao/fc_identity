defmodule FCIdentity.RouterTest do
  use FCIdentity.DataCase

  alias FCIdentity.Router
  alias FCIdentity.RegisterUser
  alias FCIdentity.{UserAdded, AccountCreated, UserRegistered}

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

      assert_receive_event(AccountCreated,
        fn(event) -> event.mode == "live" end,
        fn(event) ->
          assert event.name == "Unamed Account"
          assert event.default_locale == "en"
        end
      )

      assert_receive_event(AccountCreated,
        fn(event) -> event.mode == "test" end,
        fn(event) ->
          assert event.name == "Unamed Account"
          assert event.default_locale == "en"
        end
      )

      assert_receive_event(UserAdded, fn(event) ->
        assert event.username == String.downcase(cmd.username)
        assert event.password_hash
        assert event.email == cmd.email
        assert event.name == cmd.name
      end)

      assert_receive_event(UserRegistered, fn(event) ->
        assert event.username == String.downcase(cmd.username)
        assert event.default_account_id
        assert event.is_term_accepted == cmd.is_term_accepted
        assert event.name == cmd.name
        assert event.email == cmd.email
      end)
    end
  end
end