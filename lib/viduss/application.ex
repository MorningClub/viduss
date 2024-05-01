defmodule Viduss.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VidussWeb.Telemetry,
      Viduss.Repo,
      {DNSCluster, query: Application.get_env(:viduss, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Viduss.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Viduss.Finch},
      # Start a worker by calling: Viduss.Worker.start_link(arg)
      # {Viduss.Worker, arg},
      # Start to serve requests, typically the last entry
      VidussWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Viduss.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VidussWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
