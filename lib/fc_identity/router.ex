defmodule FCIdentity.Router do
  use Commanded.Commands.Router

  alias FCIdentity.{User, Account}
  alias FCIdentity.{RegisterUser, FinishUserRegistration, AddUser, CreateAccount}
  alias FCIdentity.{UserHandler, AccountHandler}

  middleware FCIdentity.ValidateFormat
  middleware FCIdentity.IdentifyRequester
  middleware FCIdentity.GenerateID

  dispatch RegisterUser, to: UserHandler, aggregate: User, identity: :user_id
  dispatch AddUser, to: UserHandler, aggregate: User, identity: :user_id
  dispatch FinishUserRegistration, to: UserHandler, aggregate: User, identity: :user_id

  dispatch CreateAccount, to: AccountHandler, aggregate: Account, identity: :account_id
end