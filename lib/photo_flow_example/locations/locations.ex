defmodule PhotoFlowExample.Locations do
  import Ecto.Query, warn: false
  alias PhotoFlowExample.Repo

  alias PhotoFlowExample.Locations.Place

  def list_places do
    Repo.all(Place)
  end

  def locate_geodata(%{
        "geonameId" => code,
        "name" => name,
        "population" => pop,
        "fclName" => type
      }) do
    {:ok, place} =
      PhotoFlowExample.Locations.build_place(%{code: code, name: name, pop: pop, type: type})

    place
  end

  def build_place(%{code: code, name: name, pop: pop, type: type}) do
    case Repo.one(
           from(
             p in Place,
             where: p.code == ^"#{code}"
           )
         ) do
      p when is_nil(p) ->
        {:ok, place} =
          create_place(%{
            code: "#{code}",
            name: name,
            population: pop,
            type: type
          })

        {:ok, place}

      p ->
        {:ok, p}
    end
  end

  def get_place!(id), do: Repo.get!(Place, id)

  def create_place(attrs \\ %{}) do
    %Place{}
    |> Place.changeset(attrs)
    |> Repo.insert()
  end
end
