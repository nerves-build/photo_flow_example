defmodule PhotoFlowExample.Locations.Place do
  use Ecto.Schema
  import Ecto.Changeset
  alias PhotoFlowExample.Locations.Place

  schema "places" do
    field(:code, :string)
    field(:name, :string)
    field(:pop, :integer)
    field(:type, :string)

    timestamps()
  end

  @doc false
  def changeset(%Place{} = place, attrs) do
    place
    |> cast(attrs, [:name, :code, :type, :pop])
    |> validate_required([:name, :code])
  end
end
