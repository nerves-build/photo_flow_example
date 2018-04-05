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

  alias PhotoFlowExample.Photos.Analysis

  @doc """
  Returns the list of analyses.

  ## Examples

      iex> list_analyses()
      [%Analysis{}, ...]

  """
  def list_analyses do
    Repo.all(Analysis)
  end

  @doc """
  Gets a single analysis.

  Raises `Ecto.NoResultsError` if the Analysis does not exist.

  ## Examples

      iex> get_analysis!(123)
      %Analysis{}

      iex> get_analysis!(456)
      ** (Ecto.NoResultsError)

  """
  def get_analysis!(id), do: Repo.get!(Analysis, id)

  @doc """
  Creates a analysis.

  ## Examples

      iex> create_analysis(%{field: value})
      {:ok, %Analysis{}}

      iex> create_analysis(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_analysis(attrs \\ %{}) do
    %Analysis{}
    |> Analysis.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a analysis.

  ## Examples

      iex> update_analysis(analysis, %{field: new_value})
      {:ok, %Analysis{}}

      iex> update_analysis(analysis, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_analysis(%Analysis{} = analysis, attrs) do
    analysis
    |> Analysis.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Analysis.

  ## Examples

      iex> delete_analysis(analysis)
      {:ok, %Analysis{}}

      iex> delete_analysis(analysis)
      {:error, %Ecto.Changeset{}}

  """
  def delete_analysis(%Analysis{} = analysis) do
    Repo.delete(analysis)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking analysis changes.

  ## Examples

      iex> change_analysis(analysis)
      %Ecto.Changeset{source: %Analysis{}}

  """
  def change_analysis(%Analysis{} = analysis) do
    Analysis.changeset(analysis, %{})
  end
end
