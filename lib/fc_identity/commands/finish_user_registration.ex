defmodule FCIdentity.FinishUserRegistration do
  use TypedStruct
  use Vex.Struct

  typedstruct do
    field :user_id, String.t()
    field :is_term_accepted, boolean, default: false

    validates :user_id, presence: true
    validates :is_term_accepted, acceptance: true
  end
end