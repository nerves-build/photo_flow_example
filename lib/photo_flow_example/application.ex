defmodule PhotoFlowExample.Application do
  use Application

  def start(_type, _args) do
    children = [
      PhotoFlowExample.Repo,
      PhotoFlowExampleWeb.Endpoint,
      PhotoFlowExample.FolderScan,
      PhotoFlowExample.LoudCounter
    ]

    opts = [strategy: :one_for_one, name: PhotoFlowExample.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    PhotoFlowExampleWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
