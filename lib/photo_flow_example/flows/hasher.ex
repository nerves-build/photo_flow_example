defmodule PhotoFlowExample.Flows.Hasher do
  alias PhotoFlowExample.Flows.FlowPhoto

  def execute(%FlowPhoto{original_path: path} = item) do
    {:ok, content} = File.read(path)
    hash = :crypto.hash(:md5, content) |> Base.encode16()
    FlowPhoto.add_hash(item, hash)
  end
end
