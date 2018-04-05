defmodule PhotoFlowExample.Flows.Analyzer do

  alias PhotoFlowExample.Flows.FlowPhoto
  alias PhotoFlowExample.Photos

  def execute(%FlowPhoto{original_path: path, photo: photo} = item) do
    an_data = OcvPhotoAnalyzer.analyze(path)
    {:ok, anal} = Photos.create_analysis(%{
      photo_id: photo.id,
      histogram: an_data.histogram,
      color_one: Enum.at(an_data.dominant, 0),
      color_two: Enum.at(an_data.dominant, 1),
      color_three: Enum.at(an_data.dominant, 2)
    })
    FlowPhoto.add_analysis(item, anal)
  end
end
