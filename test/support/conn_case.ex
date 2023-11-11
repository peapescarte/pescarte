defmodule PescarteWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use PescarteWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      use PescarteWeb, :verified_routes
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import PescarteWeb.ConnCase

      # The default endpoint for testing
      @endpoint PescarteWeb.Endpoint
    end
  end

  setup tags do
    Pescarte.DataCase.setup_sandbox(tags)
    conn = setup_conn()
    {:ok, conn: conn }
  end

  defp setup_conn do
    conn = Phoenix.ConnTest.build_conn()
    secret_key_base = PescarteWeb.Endpoint.config(:secret_key_base)
   Map.replace!(conn, :secret_key_base, secret_key_base)
  end

  @doc """
  Assistente de configuração que registra e efetua login do usuário.

      setup :register_and_log_in_user

  Armazena uma conexão atualizada e um usuário cadastrado no
  contexto de teste.
  """
  def register_and_log_in_user(%{conn: conn}) do
    alias Pescarte.Identidades.Factory
    user = Factory.insert(:usuario)
    %{conn: log_in_user(conn, user), user: user}
  end

  @doc """
  Registra o `usuário` fornecido no `conn`.

  Ele retorna um `conn` atualizado.
  """
  def log_in_user(conn, user) do
    alias Pescarte.Identidades.Handlers.CredenciaisHandler

    token = CredenciaisHandler.generate_session_token(user)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:user_token, token)
  end

  @token_salt "autenticação de usuário"

  @doc """
  Insere e cria um JWT para um usuário, para ser usado nos testes
  de API.

      setup :register_and_generate_jwt_token

  Atente-se pois essa função adiciona um header na `conn`
  """
  def register_and_generate_jwt_token(%{conn: conn}) do
    alias Pescarte.Identidades.Factory

    user = Factory.insert(:usuario)
    token = Phoenix.Token.sign(PescarteWeb.Endpoint, @token_salt, user.id_publico)
    %{conn: Plug.Conn.put_req_header(conn, "authorization", "Bearer " <> token), user: user}
  end
end
