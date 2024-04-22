defmodule Pescarte.Application do
  use Application

  @supabase_client Pescarte.Supabase.Client

  def supabase_client, do: @supabase_client

  @impl true
  def start(_, _) do
    session_opts = [:named_table, :public, read_concurrency: true]
    :ets.new(:pescarte_session, session_opts)
    opts = [strategy: :one_for_one, name: Pescarte.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PescarteWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children do
    if Pescarte.env() == :dev, do: Faker.start()

    [
      Pescarte.Database.Supervisor,
      PescarteWeb.Telemetry,
      {Phoenix.PubSub, name: Pescarte.PubSub},
      PescarteWeb.Endpoint,
      Pescarte.CotacoesETL.InjesterSupervisor,
      # ChromicPDF,
      Pescarte.Supabase,
    ]
  end
end
