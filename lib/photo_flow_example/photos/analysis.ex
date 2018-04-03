defmodule PhotoFlowExample.Photos.Analysis do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhotoFlowExample.Photos.Photo
  alias PhotoFlowExample.Photos.Analysis


  schema "analyses" do
    field :color_one, :map
    field :color_two, :map
    field :color_three, :map
    field :histogram, :map

    belongs_to(:photo, Photo)

    timestamps()
  end


  @doc false
  def changeset(%Analysis{} = analysis, attrs) do
    analysis
    |> cast(attrs, [:histogram, :color_one, :color_two, :color_three])
  end
end
