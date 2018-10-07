defmodule FCIdentity.UserHandler do
  @behaviour Commanded.Commands.Handler

  use OK.Pipe

  import Comeonin.Argon2
  import FCIdentity.{Support, Validation, Normalization}

  alias FCIdentity.{RegisterUser, AddUser}
  alias FCIdentity.{UserRegistrationRequested, FinishUserRegistration, UserAdded, UserRegistered}

  def handle(%{user_id: nil}, %RegisterUser{} = cmd) do
    struct_merge(%UserRegistrationRequested{}, cmd)
  end

  def handle(_, %RegisterUser{}), do: {:error, :user_already_registered}

  def handle(%{user_id: nil}, %AddUser{} = cmd) do
    cmd
    |> trim_strings()
    |> put_name()
    |> validate(name: [presence: true])
    ~> to_event(%UserAdded{type: cmd._type_})
    ~> put_password_hash(cmd)
    |> unwrap_ok()
  end

  def handle(_, %AddUser{}), do: {:error, :user_already_exist}

  def handle(%{user_id: nil}, %FinishUserRegistration{}), do: {:error, :user_not_found}

  def handle(%{user_id: user_id} = state, %FinishUserRegistration{} = event) do
    %UserRegistered{
      user_id: user_id,
      default_account_id: state.account_id,
      username: state.username,
      password_hash: state.password_hash,
      email: state.email,
      is_term_accepted: event.is_term_accepted,
      first_name: state.first_name,
      last_name: state.last_name,
      name: state.name
    }
  end

  defp to_event(cmd, event) do
    struct_merge(event, cmd)
  end

  defp put_name(%{name: name} = cmd) when byte_size(name) > 0 do
    cmd
  end

  defp put_name(cmd) do
    name = String.trim("#{cmd.first_name} #{cmd.last_name}")
    %{cmd | name: name}
  end

  defp put_password_hash(event, %{password: password}) when byte_size(password) > 0 do
    %{event | password_hash: hashpwsalt(password)}
  end

  defp put_password_hash(event, _), do: event
end