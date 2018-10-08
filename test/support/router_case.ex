defmodule FCIdentity.RouterCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import Commanded.Assertions.EventAssertions
      import FCIdentity.RouterCase
    end
  end

  setup do
    {:ok, _} = Application.ensure_all_started(:fc_identity)

    on_exit(fn ->
      :ok = Application.stop(:fc_identity)
      :ok = Application.stop(:commanded)
      :ok = Application.stop(:eventstore)

      FCIdentity.Storage.reset!()
    end)

    :ok
  end
end