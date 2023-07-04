defmodule Pescarte.MixProject do
  use Mix.Project

  @read_repo Database.EscritaRepo

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: [
        pescarte: [
          applications: [
            database: :permanent,
            cotacoes: :permanent,
            proxy_web: :permanent,
            identidades: :permanent,
            modulo_pesquisa: :permanent,
            plataforma_digital: :permanent,
            plataforma_digital_api: :permanent
          ]
        ]
      ]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": [
        "ecto.create -r #{@read_repo}",
        "ecto.migrate -r #{@read_repo} #{migrations_paths()}",
        "seed"
      ],
      "ecto.migrate": [
        "ecto.migrate -r #{@read_repo} #{migrations_paths()}"
      ],
      "ecto.rollback": [
        "ecto.rollback -r #{@read_repo} #{migrations_paths()}"
      ],
      test: [
        "ecto.create -r #{@read_repo} --quiet",
        "ecto.migrate -r #{@read_repo} --quiet #{migrations_paths()}",
        "test"
      ],
      "assets.build": [
        "esbuild default",
        "sass default",
        "tailwind default",
        "tailwind storybook"
      ],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default",
        "tailwind default --minify",
        "tailwind storybook --minify",
        "phx.digest"
      ]
    ]
  end

  defp migrations_paths do
    paths = [
      "apps/identidades/priv/repo/migrations",
      "apps/modulo_pesquisa/priv/repo/migrations",
      "apps/cotacoes/priv/repo/migrations"
    ]

    for path <- paths, reduce: "" do
      acc -> "--migrations-path #{path}" <> " " <> acc
    end
  end
end
