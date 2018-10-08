defmodule FCIdentity.UserPolicy do
  alias FCIdentity.{RegisterUser, AddUser}

  def authorize(%{requester_role: "system"} = cmd, _), do: {:ok, cmd}
  def authorize(%{requester_role: "sysdev"} = cmd, _), do: {:ok, cmd}

  def authorize(%AddUser{requester_role: role} = cmd, _) when role in ["owner", "administrator"] do
    {:ok, cmd}
  end

  def authorize(_, _), do: {:error, :access_denied}
end