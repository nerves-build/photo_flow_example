defmodule PhotoFlowExample.Photos.Content do
  use Arc.Definition
  use Arc.Ecto.Definition

  # To add a thumbnail version:
  @versions [:original, :thumb]

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png .JPG) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  end

  def storage_dir(_version, {_file, scope}) do
    "#{dest_folder()}/#{scope.id}"
  end

  defp dest_folder do
    Application.get_env(:photo_flow_example, PhotoFlowExample)[:image_destination]
  end
end
