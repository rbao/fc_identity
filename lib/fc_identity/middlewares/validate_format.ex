defmodule FCIdentity.ValidateFormat do
  @behaviour Commanded.Middleware

  alias Commanded.Middleware.Pipeline
  alias FCIdentity.Validation

  def before_dispatch(%Pipeline{command: cmd} = pipeline) do
    if Vex.valid?(cmd) do
      pipeline
    else
      %{pipeline | halted: true, response: {:error, {:validation_failed, Validation.errors(cmd)}}}
    end
  end

  def after_dispatch(pipeline), do: pipeline
  def after_failure(pipeline), do: pipeline
end