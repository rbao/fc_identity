defmodule FCIdentity.UserRegistration do
  use TypedStruct
  use Commanded.ProcessManagers.ProcessManager,
    name: "1c03fc1e-af6b-42f4-96f6-2685114677e9",
    router: FCIdentity.Router

  import FCIdentity.Support
  alias FCIdentity.{UserRegistrationRequested, UserAdded, AccountCreated, UserRegistered}
  alias FCIdentity.{AddUser, CreateAccount, FinishUserRegistration}

  typedstruct do
    field :user_id, String.t()
    field :account_id, String.t()
    field :is_term_accepted, boolean, default: false
    field :is_user_added, boolean, default: false
    field :is_account_created, boolean, default: false
  end

  def interested?(%UserRegistrationRequested{user_id: user_id}), do: {:start, user_id}
  def interested?(%UserAdded{user_id: user_id}), do: {:continue, user_id}
  def interested?(%AccountCreated{owner_id: owner_id}), do: {:continue, owner_id}
  def interested?(%UserRegistered{user_id: user_id}), do: {:stop, user_id}
  def interested?(_), do: false

  def handle(_, %UserRegistrationRequested{} = event) do
    add_user = %AddUser{
      _type_: "standard",
      requester_role: :system,
      account_id: event.default_account_id,
      status: "pending",
      role: "owner"
    }
    add_user = struct_merge(add_user, event)

    create_account = %CreateAccount{
      account_id: event.default_account_id,
      owner_id: event.user_id,
      name: event.account_name,
      default_locale: event.default_locale
    }

    [create_account, add_user]
  end

  def handle(%{is_user_added: true} = state, %AccountCreated{}) do
    %FinishUserRegistration{user_id: state.user_id, is_term_accepted: state.is_term_accepted}
  end

  def handle(%{is_account_created: true} = state, %UserAdded{} = event) do
    %FinishUserRegistration{user_id: event.user_id, is_term_accepted: state.is_term_accepted}
  end

  def apply(state, %UserRegistrationRequested{} = event) do
    %{state | is_term_accepted: event.is_term_accepted}
  end

  def apply(%{is_user_added: false} = state, %UserAdded{} = event) do
    %{state | is_user_added: true, user_id: event.user_id}
  end

  def apply(%{is_account_created: false} = state, %AccountCreated{} = event) do
    %{state | is_account_created: true, account_id: event.account_id}
  end
end