defmodule FCIdentity.AccountHandler do
  @behaviour Commanded.Commands.Handler

  import FCIdentity.Support

  alias FCIdentity.{CreateAccount}
  alias FCIdentity.{AccountCreated}
  alias FCIdentity.Account

  def handle(%Account{account_id: nil}, %CreateAccount{mode: mode} = cmd) do
    struct_merge(%AccountCreated{}, cmd)
  end

  def handle(%Account{account_id: _}, %CreateAccount{}) do
    {:error, :account_already_exist}
  end
end