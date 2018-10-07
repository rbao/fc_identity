defmodule FCIdentity.Account do
  use TypedStruct

  import FCIdentity.Support

  alias FCIdentity.AccountCreated

  typedstruct do
    field :account_id, String.t()
    field :owner_id, String.t()

    field :name, String.t()
    field :default_locale, String.t()
  end

  def apply(%__MODULE__{} = state, %AccountCreated{} = event) do
    %__MODULE__{state | account_id: event.account_id}
    |> struct_merge(event)
  end
end