defmodule BourdoxCore.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BourdoxWeb.Telemetry,
      BourdoxCore.Repo,
      {DNSCluster, query: Application.get_env(:bourdox, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BourdoxCore.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: BourdoxCore.Finch},
      # Start a worker by calling: BourdoxCore.Worker.start_link(arg)
      # {BourdoxCore.Worker, arg},
      # Start to serve requests, typically the last entry
      BourdoxWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BourdoxCore.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BourdoxWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
