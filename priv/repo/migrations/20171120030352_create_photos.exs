defmodule PhotoFlowExample.Repo.Migrations.CreatePhotos do
  use Ecto.Migration

  def change do
    create table(:photos) do
      add :name, :string
      add :title, :string
      add :hash, :string, unique: true
      add :created_at, :naive_datetime
      add :modified_at, :naive_datetime
      add :taken_at, :naive_datetime
      add :size, :integer
      add :rating, :integer
      add :width, :integer
      add :height, :integer
      add :lat, :float
      add :lng, :float
      add :exif_data, :string
      add :content, :string

      timestamps()
    end
  create unique_index("photos", [:hash])
  end
end
