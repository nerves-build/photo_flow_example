defmodule PhotoFlowExample.Photos.Photo do
  use Ecto.Schema
  import Ecto.Changeset
  use Arc.Ecto.Schema
  alias PhotoFlowExample.Photos.Photo
  alias PhotoFlowExample.Locations.Place

  schema "photos" do
    field(:name, :string)
    field(:hash, :string)
    field(:size, :integer)
    field(:width, :integer)
    field(:height, :integer)
    field(:created_at, :naive_datetime)
    field(:modified_at, :naive_datetime)
    field(:taken_at, :naive_datetime)
    field(:rating, :integer)
    field(:title, :string)
    field(:exif_data, :string)
    field(:lat, :float)
    field(:lng, :float)
    field(:content, PhotoFlowExample.Photos.Content.Type)

    belongs_to(:place, Place)

    timestamps()
  end

  @fields [
    :name,
    :title,
    :hash,
    :created_at,
    :modified_at,
    :taken_at,
    :rating,
    :lat,
    :lng,
    :exif_data,
    :size,
    :width,
    :height
  ]

  @doc false
  def changeset(photo \\ %Photo{}, attrs) do
    photo
    |> cast(attrs, @fields)
    |> cast_attachments(attrs, [:content])
    |> unique_constraint(:hash)
  end
end
