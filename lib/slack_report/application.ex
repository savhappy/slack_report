defmodule SlackReport.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SlackReportWeb.Telemetry,
      SlackReport.Repo,
      {DNSCluster, query: Application.get_env(:slack_report, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SlackReport.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SlackReport.Finch},
      {SlackReport.ChildSupervisor, 1},
      # {SlackReport.Worker, arg},
      # Start a worker by calling: SlackReport.Worker.start_link(arg)
      # {SlackReport.Worker, arg},
      # Start to serve requests, typically the last entry
      SlackReportWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SlackReport.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SlackReportWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
