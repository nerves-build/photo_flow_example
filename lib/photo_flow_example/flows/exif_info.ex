defmodule PhotoFlowExample.Flows.ExifInfo do
  defstruct width: nil,
            height: nil,
            taken_at: nil,
            lat: nil,
            lng: nil,
            exif_data: nil

  require Logger

  alias PhotoFlowExample.Flows.{FlowPhoto, ExifInfo}

  def execute(%FlowPhoto{original_path: path} = item) do
    try do
      case Exexif.exif_from_jpeg_file(path) do
        {:ok, exif} ->
          FlowPhoto.add_exif_info(item, filter_exif_data(exif))

        {:error, :not_a_jpeg_file} ->
          FlowPhoto.add_error(item, :x_file_type_error)

        _ ->
          FlowPhoto.add_error(item, :x_exif_error)
      end
    rescue
      _e ->
        Logger.warn("exifinfo error exception")
        FlowPhoto.add_error(item, :x_exif_error)
    end
  end

  defp filter_exif_data(%{exif: exif_data, gps: gps_data}) do
    %ExifInfo{
      taken_at: exif_data[:datetime_original] |> do_parse_datetime,
      width: exif_data[:exif_image_width],
      height: exif_data[:exif_image_height],
      exif_data: Poison.encode!(exif_data),
      lat: do_parse_lat(gps_data.gps_latitude, gps_data.gps_latitude_ref),
      lng: do_parse_lng(gps_data.gps_longitude, gps_data.gps_longitude_ref)
    }
  end

  defp filter_exif_data(%{exif: exif_data} = data) do
    %ExifInfo{
      taken_at: exif_data[:datetime_original] |> do_parse_datetime,
      width: exif_data[:exif_image_width],
      height: exif_data[:exif_image_height],
      exif_data: Poison.encode!(data)
    }
  end

  defp do_parse_lat([hrs, min, sec], "N"), do: calc_decimal(hrs, min, sec)
  defp do_parse_lat([hrs, min, sec], "S"), do: 0 - calc_decimal(hrs, min, sec)
  defp do_parse_lat(_lat, _lat_ref), do: nil

  defp do_parse_lng([hrs, min, sec], "E"), do: calc_decimal(hrs, min, sec)
  defp do_parse_lng([hrs, min, sec], "W"), do: 0 - calc_decimal(hrs, min, sec)
  defp do_parse_lng(_lng, _lng_ref), do: nil

  defp calc_decimal(hrs, min, sec) do
    hrs + min / 60 + sec / 3600
  end

  defp do_parse_datetime(nil), do: nil

  defp do_parse_datetime(date_time_str) do
    case Timex.parse(date_time_str, "%Y:%m:%d %H:%M:%S", :strftime) do
      {:ok, ans} ->
        ans

      {:error, msg} ->
        Logger.warn("Exif Info generated error #{msg} for #{inspect(date_time_str)}")
        nil
    end
  end
end
