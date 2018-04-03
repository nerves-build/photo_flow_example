defmodule PhotoFlowExample.Flows.Persister do
  alias PhotoFlowExample.Flows.FlowPhoto
  alias PhotoFlowExample.Photos

  def not_persisted(item)
  def not_persisted(%FlowPhoto{photo: nil} = item), do: reject_item(item)
  def not_persisted(%FlowPhoto{photo: _photo}), do: false
  def not_persisted(item), do: reject_item(item)

  def execute(%FlowPhoto{original_path: path} = item) do
    case create_photo(item) do
      {:ok, new_photo} ->
        Photos.store_content({path, new_photo})
        FlowPhoto.set_photo(item, new_photo)

      _ ->
        FlowPhoto.add_error(item, :x_duplicate)
    end
  end

  defp reject_item(item) do
    FlowPhoto.add_error(item, :x_rejected)
    true
  end

  defp create_photo(%FlowPhoto{original_path: path, hash: hash}) do
    %{
      name: Path.basename(path),
      path: path,
      hash: hash
    }
    |> Photos.create_photo()
  end

  def update_photo(%FlowPhoto{photo: photo} = item) do
    attr = photo_attributes(item)
      |> place_attributes(item)

    Photos.update_photo(photo, attr)
    item
  end

  defp photo_attributes(%FlowPhoto{
         original_path: path,
         file_info: finfo,
         hash: hash,
         exif_info: nil
       }) do
    %{
      name: Path.basename(path),
      path: path,
      hash: hash,
      size: finfo.size,
      created_at: finfo.created_at,
      modified_at: finfo.modified_at
    }
  end

  defp photo_attributes(%FlowPhoto{
         original_path: path,
         file_info: finfo,
         hash: hash,
         exif_info: exifs,
       }) do
    %{
      name: Path.basename(path),
      path: path,
      hash: hash,
      size: finfo.size,
      created_at: finfo.created_at,
      modified_at: finfo.modified_at,
      width: exifs.width,
      height: exifs.height,
      taken_at: exifs.taken_at,
      lat: exifs.lat,
      lng: exifs.lng,
      exif_data: exifs.exif_data
    }
  end

  defp place_attributes(attr, %FlowPhoto{place: nil}), do: attr

  defp place_attributes(attr, %FlowPhoto{place: place}) do
    Map.merge(attr, %{place_id: place.id})
  end
end
