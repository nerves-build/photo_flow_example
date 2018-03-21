defmodule PhotoFlowExample.Flows.FileInfo do
  defstruct size: nil,
            created_at: nil,
            modified_at: nil

  alias PhotoFlowExample.Flows.{FileInfo, FlowPhoto}

  def execute(%FlowPhoto{original_path: path} = item) do
    {:ok, stat_data} = File.stat(path)
    FlowPhoto.add_file_info(item, from_stat_info(stat_data))
  end

  defp from_stat_info(stat_info) do
    %FileInfo{
      size: stat_info.size,
      created_at: NaiveDateTime.from_erl!(stat_info.ctime),
      modified_at: NaiveDateTime.from_erl!(stat_info.mtime)
    }
  end
end
