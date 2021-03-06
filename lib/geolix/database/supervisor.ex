defmodule Geolix.Database.Supervisor do
  @moduledoc false

  use Supervisor

  @doc false
  def start_link(default \\ []) do
    Supervisor.start_link(__MODULE__, default, name: __MODULE__)
  end

  @doc false
  def init(_default), do: supervise([], strategy: :one_for_all)

  @doc """
  Starts the worker processes of a database if not already under supervision.
  """
  @spec start_database(map) :: :ok
  def start_database(database) do
    database
    |> database_workers()
    |> Enum.each(&Supervisor.start_child(__MODULE__, &1))
  end

  defp database_workers(%{adapter: adapter} = database) do
    if function_exported?(adapter, :database_workers, 1) do
      adapter.database_workers(database)
    else
      []
    end
  end

  defp database_workers(_), do: []
end
