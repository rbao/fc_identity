defmodule FCIdentity.AccountCreated do
  use TypedStruct

  @version 1

  typedstruct do
    field :__version__, integer(), default: @version

    field :account_id, String.t()
    field :owner_id, String.t()

    field :name, String.t()
    field :default_locale, String.t()
  end
end