defmodule PhotoFlowExample.Repo.Migrations.CreateAnalyses do
  use Ecto.Migration

  def change do
    create table(:analyses) do
      add :histogram, :string
      add :color_one, :string
      add :color_two, :string
      add :color_three, :string
      add :photo_id, :integer

      timestamps()
    end
  end
end
