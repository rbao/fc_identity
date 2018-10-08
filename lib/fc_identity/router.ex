defmodule FCIdentity.Router do
  use Commanded.Commands.Router

  alias FCIdentity.{User, Account}
  alias FCIdentity.{RegisterUser, FinishUserRegistration, AddUser, CreateAccount}
  alias FCIdentity.{UserHandler, AccountHandler}

  middleware FCIdentity.ValidateFormat
  middleware FCIdentity.IdentifyRequester
  middleware FCIdentity.GenerateID

  identify User, by: :user_id, prefix: "user-"
  identify Account, by: :account_id, prefix: "account-"

  dispatch [RegisterUser, AddUser, FinishUserRegistration],
    to: UserHandler, aggregate: User

  dispatch CreateAccount, to: AccountHandler, aggregate: Account
end