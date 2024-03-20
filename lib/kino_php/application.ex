defmodule KinoPHP.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoPHP.ScriptCell)

    children = []
    opts = [strategy: :one_for_one, name: KinoPHP.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
