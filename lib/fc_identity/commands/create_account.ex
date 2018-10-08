defmodule FCIdentity.CreateAccount do
  use TypedStruct
  use Vex.Struct

  typedstruct do
    field :account_id, String.t()
    field :owner_id, String.t()

    field :mode, String.t(), default: "live"
    field :live_account_id, String.t()
    field :test_account_id, String.t()

    field :name, String.t(), default: "Unamed Account"
    field :default_locale, String.t(), default: "en"

    validates :owner_id, presence: true
    validates :name, presence: true
    validates :default_locale, presence: true
  end
end
