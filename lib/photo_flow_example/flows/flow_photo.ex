defmodule PhotoFlowExample.Flows.FlowPhoto do
  defstruct original_path: "",
            hash: nil,
            photo: nil,
            place: nil,
            geodata: nil,
            exif_info: nil,
            file_info: nil,
            analysis: nil

  alias PhotoFlowExample.Flows.{FlowPhoto, FileInfo, ExifInfo}
  alias PhotoFlowExample.LoudCounter
  alias PhotoFlowExample.Photos.{Photo, Analysis}
  alias PhotoFlowExample.Locations.Place

  @doc false
  def from_path(s) do
    LoudCounter.increment_tag(:ingested, 1)

    %FlowPhoto{
      original_path: s
    }
  end

  def add_hash(%FlowPhoto{} = fp, hash) do
    LoudCounter.increment_tag(:hash, 1)
    %{fp | hash: hash}
  end

  def add_file_info(%FlowPhoto{} = fp, %FileInfo{} = info) do
    LoudCounter.increment_tag(:finfo, 1)
    %{fp | file_info: info}
  end

  def add_analysis(%FlowPhoto{} = fp, %Analysis{} = data) do
    LoudCounter.increment_tag(:analyze, 1)
    %{fp | analysis: data}
  end

  def add_exif_info(%FlowPhoto{} = fp, %ExifInfo{} = info) do
    LoudCounter.increment_tag(:exif, 1)
    %{fp | exif_info: info}
  end

  def set_photo(%FlowPhoto{} = fp, %Photo{} = photo) do
    LoudCounter.increment_tag(:persist, 1)
    %{fp | photo: photo}
  end

  def set_geodata(%FlowPhoto{} = fp, nil), do: fp

  def set_geodata(fp, geodata) do
    LoudCounter.increment_tag(:geolocate, 1)
    %{fp | geodata: geodata}
  end

  def set_place(%FlowPhoto{} = fp, nil), do: fp

  def set_place(fp, %Place{} = place) do
    LoudCounter.increment_tag(:geopersist, 1)
    %{fp | place: place}
  end

  def clear_path(%FlowPhoto{} = fp) do
    LoudCounter.increment_tag(:delete, 1)
    %{fp | original_path: ""}
  end

  def add_error(%FlowPhoto{} = fp, tag) do
    LoudCounter.increment_tag(tag, 1)
    fp
  end

  def get_photo(%FlowPhoto{} = fp) do
    LoudCounter.increment_tag(:completed, 1)
    fp.photo
  end
end
