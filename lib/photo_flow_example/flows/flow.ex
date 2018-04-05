defmodule PhotoFlowExample.Flows.Flow do
  alias PhotoFlowExample.Flows.{ExifInfo, FileInfo, Hasher, Geonames, FlowPhoto, Persister, Analyzer}
  alias PhotoFlowExample.FolderScan

  def start_flow do
    FolderScan.start_files_stream(5)
    |> Flow.from_enumerable(max_demand: 20)
    |> Flow.partition(max_demand: 5, stages: 6)
    |> Flow.map(&create_flow_photo(&1))
    |> Flow.map(&Hasher.execute(&1))
    |> Flow.map(&Persister.execute(&1))
    |> Flow.reject(&Persister.not_persisted(&1))
    |> Flow.map(&FileInfo.execute(&1))
    |> Flow.map(&ExifInfo.execute(&1))
    |> Flow.map(&Analyzer.execute(&1))
    |> Flow.map(&Geonames.fetch(&1))
    |> Flow.partition(key: fn p -> Geonames.place_key(p) end, stages: 6)
    |> Flow.map(&Geonames.get_or_create_place(&1))
    |> Flow.map(&Persister.update_photo(&1))
    |> Flow.map(&finish_flow_photo(&1))
    |> Flow.run()

    start_flow()
  end

  def create_flow_photo(path) do
    FlowPhoto.from_path(path)
  end

  def finish_flow_photo(item) do
    FlowPhoto.get_photo(item)
  end
end
