defmodule FCIdentity.MemoryStore do
  @behaviour FCIdentity.SimpleStore

  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def get(primary_key, _ \\ []) do
    Agent.get(__MODULE__, fn(table) ->
      table[primary_key]
    end)
  end

  def put(record, opts \\ [])

  def put(record, allow_overwrite: false) do
    if get(record.key) do
      {:error, :key_already_exist}
    else
      Agent.update(__MODULE__, fn(table) ->
        Map.put(table, record[:key], record)
      end)

      {:ok, record}
    end
  end

  def put(record, _) do
    Agent.update(__MODULE__, fn(table) ->
      Map.put(table, record[:key], record)
    end)

    {:ok, record}
  end
end