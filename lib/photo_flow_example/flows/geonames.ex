defmodule PhotoFlowExample.Flows.Geonames do
  alias PhotoFlowExample.Flows.FlowPhoto
  alias PhotoFlowExample.Locations

  require Logger

  @two_minutes 1000 * 60 * 2
  @six_minutes 1000 * 60 * 6

  def place_key(%FlowPhoto{geodata: nil}), do: ""

  def place_key(%FlowPhoto{geodata: geodata}) do
    "#{geodata["geonameId"]}"
  end

  def fetch(%FlowPhoto{exif_info: %{lat: nil, lng: nil}} = item),
    do: FlowPhoto.set_geodata(item, nil)

  def fetch(%FlowPhoto{exif_info: %{lat: 0.0, lng: 0.0}} = item),
    do: FlowPhoto.set_geodata(item, nil)

  def fetch(%FlowPhoto{exif_info: %{lat: lat, lng: lng}} = item) do
    FlowPhoto.set_geodata(item, do_locate_place(lat, lng))
  end

  def fetch(item), do: FlowPhoto.set_geodata(item, nil)

  def get_or_create_place(%FlowPhoto{geodata: nil} = item), do: FlowPhoto.set_place(item, nil)

  def get_or_create_place(%FlowPhoto{geodata: geodata} = item) do
    FlowPhoto.set_place(item, Locations.locate_geodata(geodata))
  end

  def get_or_create_place(item), do: FlowPhoto.set_place(item, nil)

  defp do_locate_place(lat, lng) do
    case Hammer.check_rate("geonames/find_nearby_place_name", @six_minutes, 60) do
      {:allow, _count} ->
        try do
          case Geonames.find_nearby_place_name(%{lat: lat, lng: lng}) do
            %{"geonames" => [geo_data]} ->
              geo_data

            %{"status" => %{"message" => msg}} ->
              Logger.warn("Geonames Error, #{msg}")
              Process.sleep(@two_minutes)
              do_locate_place(lat, lng)
          end
        rescue
          _e in RuntimeError ->
            Logger.warn("Geonames RuntimeError, resting briefly")
            Process.sleep(@two_minutes)
            do_locate_place(lat, lng)
        end

      {:deny, _limit} ->
        Logger.warn("Geonames timeout")
        Process.sleep(@two_minutes)
        do_locate_place(lat, lng)
    end
  end
end
