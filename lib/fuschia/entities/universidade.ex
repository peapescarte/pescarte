defmodule Fuschia.Entities.Universidade do
  @moduledoc """
  Universidade Schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Cidade

  @required_fields ~w(nome)a

  @primary_key {:nome, :string, []}
  schema "universidade" do
    belongs_to :cidade, Cidade,
      type: :string,
      on_replace: :delete,
      references: :municipio,
      foreign_key: :cidade_municipio

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:cidade, required: true)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        nome: struct.nome,
        cidade: struct.cidade
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
