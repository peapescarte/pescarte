defmodule Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal do
  use Pescarte, :model

  import Pescarte.Domains.ModuloPesquisa.Services.ValidateRelatorioMensal

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @status ~w(entregue atrasado nao_enviado)a

  @required_fields ~w(ano mes pesquisador_id)a

  @optional_fields ~w(
    acao_planejamento
    participacao_grupos_estudo
    acoes_pesquisa
    participacao_treinamentos
    publicacao
    previsao_acao_planejamento
    previsao_participacao_grupos_estudo
    previsao_participacao_treinamentos
    previsao_acoes_pesquisa
    status
    link
  )a

  @update_fields @optional_fields ++ ~w(year month link)a

  schema "relatorio_mensal_pesquisa" do
    # Primeira seção
    field :acao_planejamento, :string
    field :participacao_grupos_estudo, :string
    field :acoes_pesquisa, :string
    field :participacao_treinamentos, :string
    field :publicacao, :string

    # Segunda seção
    field :previsao_acao_planejamento, :string
    field :previsao_participacao_grupos_estudo, :string
    field :previsao_participacao_treinamentos, :string
    field :previsao_acoes_pesquisa, :string

    field :status, Ecto.Enum, values: @status, default: :nao_enviado
    field :ano, :integer
    field :mes, :integer
    field :link, :string
    field :id_publico, :string

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    timestamps()
  end

  def changeset(report \\ %__MODULE__{}, attrs) do
    report
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_month(:mes)
    |> validate_year(:ano, Date.utc_today())
    |> foreign_key_constraint(:pesquisador_id)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def update_changeset(report, attrs) do
    report
    |> cast(attrs, @update_fields)
    |> validate_month(:mes)
    |> validate_year(:ano, Date.utc_today())
  end
end
