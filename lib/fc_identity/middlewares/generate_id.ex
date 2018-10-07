defmodule FCIdentity.GenerateID do
  @behaviour Commanded.Middleware

  import FCIdentity.Support, only: [generate_ids: 1]
  alias Commanded.Middleware.Pipeline

  def before_dispatch(%Pipeline{} = pipeline) do
    %{pipeline | command: generate_ids(pipeline.command)}
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline
end