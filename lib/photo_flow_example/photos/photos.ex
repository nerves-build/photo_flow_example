defmodule PhotoFlowExample.Photos do

  import Ecto.Query, warn: false
  alias PhotoFlowExample.Repo

  alias PhotoFlowExample.Photos.{Content, Photo}

  def list_photos do
    Repo.all(Photo)
  end

  def get_photo!(id), do: Repo.get!(Photo, id)

  def create_photo!(attrs \\ %{}) do
    case create_photo(attrs) do
      {:ok, photo} ->
        photo

      {:err, reason} ->
        raise reason
    end
  end

  def create_photo(attrs \\ %{}) do
    %Photo{}
    |> Photo.changeset(attrs)
    |> Repo.insert()
  end

  def store_content({path, new_photo}) do
    Content.store({path, new_photo})
  end

  def update_photo!(photo, attrs \\ %{}) do
    case update_photo(photo, attrs) do
      {:ok, photo} ->
        photo

      {:error, changeset} ->
        raise inspect(changeset.errors)
    end
  end

  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  def delete_photo(%Photo{} = photo) do
    Repo.delete(photo)
  end

  def change_photo(%Photo{} = photo) do
    Photo.changeset(photo, %{})
  end
end
