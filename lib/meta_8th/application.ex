defmodule Meta8th.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Meta8thWeb.Telemetry,
      Meta8th.Repo,
      Meta8th.Redix,
      {DNSCluster, query: Application.get_env(:meta_8th, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Meta8th.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Meta8th.Finch},
      # Start a worker by calling: Meta8th.Worker.start_link(arg)
      # {Meta8th.Worker, arg},
      # Start to serve requests, typically the last entry
      Meta8thWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Meta8th.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    Meta8thWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
