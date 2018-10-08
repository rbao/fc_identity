defmodule FCIdentity.UpdateAccountInfo do
  use TypedStruct
  use Vex.Struct

  typedstruct do
    field :account_id, String.t()
    field :locale, String.t()
    field :effective_keys, [atom], default: []

    field :name, String.t()
    field :legal_name, String.t()
    field :website_url, String.t()
    field :support_email, String.t()
    field :tech_email, String.t()

    field :caption, String.t()
    field :description, String.t()
    field :custom_data, map

    @email_regex Application.get_env(:fc_identity, :email_regex)

    validates :account_id, presence: true, uuid: true
    validates :name, presence: true
    validates :support_email, format: [with: @email_regex, allow_nil: true]
    validates :tech_email, format: [with: @email_regex, allow_nil: true]
  end
end
