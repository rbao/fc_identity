defmodule FCIdentity.RequesterIdentification do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  alias FCIdentity.RoleKeeper

  def before_dispatch(%Pipeline{} = pipeline) do
    %{pipeline | command: identify(pipeline.command)}
  end

  defp identify(%{requester_role: nil, account_id: nil} = cmd) do
    %{cmd | requester_role: "anonymous"}
  end

  defp identify(%{requester_role: nil, account_id: _, requester_id: nil} = cmd) do
    %{cmd | requester_role: "guest"}
  end

  defp identify(%{requester_role: nil, account_id: _, requester_id: _} = cmd) do
    %{cmd | requester_role: RoleKeeper.get(cmd.requester_id, cmd.account_id)}
  end

  defp identify(%{requester_role: nil, account_id: _} = cmd) do
    %{cmd | requester_role: "guest"}
  end

  defp identify(cmd), do: cmd

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline
end