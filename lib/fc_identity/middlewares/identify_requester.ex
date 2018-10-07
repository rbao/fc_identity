defmodule FCIdentity.IdentifyRequester do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  alias FCIdentity.SimpleStore
  alias FCIdentity.RoleKeeper

  def before_dispatch(%Pipeline{} = pipeline) do
    %{pipeline | command: identify_requester(pipeline.command)}
  end

  defp identify_requester(%{requestor_role: _, account_id: nil} = cmd) do
    %{cmd | requestor_role: "anonymous"}
  end

  defp identify_requester(%{requestor_role: _, account_id: _, requestor_id: nil} = cmd) do
    %{cmd | requestor_role: "guest"}
  end

  defp identify_requester(%{requestor_role: _, account_id: _, requestor_id: _} = cmd) do
    id = RoleKeeper.generate_key(cmd.account_id, cmd.requestor_id)

    case SimpleStore.get(%{id: id}) do
      %{role: role} -> %{cmd | requestor_role: role}
      _ -> cmd
    end
  end

  defp identify_requester(%{requestor_role: _, account_id: _} = cmd) do
    %{cmd | requestor_role: "guest"}
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline
end