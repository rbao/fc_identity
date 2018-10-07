defmodule FCIdentity.DataCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import UUID
      import Commanded.Assertions.EventAssertions
      import FCIdentity.DataCase
    end
  end

  setup do
    {:ok, _} = Application.ensure_all_started(:fc_identity)
    {:ok, _} = FCIdentity.MemoryStore.start_link(:ok)

    on_exit(fn ->
      :ok = Application.stop(:fc_identity)
      :ok = Application.stop(:commanded)
      :ok = Application.stop(:eventstore)

      FCIdentity.Storage.reset!()
    end)

    :ok
  end

  def has_error(errors, target_key, target_reason) do
    Enum.any?(errors, fn(error) ->
      {:error, key, reason} = error
      key == target_key && reason == target_reason
    end)
  end
end