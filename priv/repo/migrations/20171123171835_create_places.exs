defmodule PhotoFlowExample.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
      add :name, :string
      add :code, :string
      add :type, :string
      add :pop, :integer

      timestamps()
    end

    alter table(:photos) do
      add :place_id, references(:places)
    end
  end
end
