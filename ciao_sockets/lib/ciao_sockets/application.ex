defmodule CiaoSockets.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :ok = CiaoSockets.Statix.connect()

    children = [
      # Start the Telemetry supervisor
      CiaoSocketsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: CiaoSockets.PubSub},
      # Start the Endpoint (http/https)
      CiaoSocketsWeb.Endpoint
      # Start a worker by calling: CiaoSockets.Worker.start_link(arg)
      # {CiaoSockets.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CiaoSockets.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CiaoSocketsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
