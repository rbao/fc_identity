defmodule FCIdentity.UserAdded do
  use TypedStruct

  @version 1

  typedstruct do
    field :__version__, integer(), default: @version

    field :account_id, String.t()

    field :type, String.t()
    field :user_id, String.t()
    field :status, String.t()
    field :username, String.t()
    field :password_hash, String.t()
    field :email, String.t()

    field :first_name, String.t()
    field :last_name, String.t()
    field :name, String.t()

    field :role, String.t()
  end
end