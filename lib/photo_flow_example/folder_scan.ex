defmodule PhotoFlowExample.FolderScan do
  use GenServer
  alias PhotoFlowExample.FolderScan
  alias PhotoFlowExample.LoudCounter

  def start_link(_data) do
    GenServer.start_link(__MODULE__, start_data(), name: FolderScan)
  end

  def start_files_stream(count) do
    Stream.resource(
      fn ->
        GenServer.call(FolderScan, :scan)
        count
      end,
      fn count -> GenServer.call(FolderScan, {:start_files_stream, count}) end,
      fn count -> count end
    )
  end

  def init(data) do
    {:ok, data}
  end

  def handle_call({:start_files_stream, count}, _from, %{files: []} = state) do
    {:reply, {:halt, count}, state}
  end

  def handle_call({:start_files_stream, count}, _from, %{files: file_list} = state) do
    {front, rest} = Enum.split(file_list, count)
    {:reply, {front, count}, Map.put(state, :files, rest)}
  end

  def handle_call(:scan, _from, %{scanned: false} = state) do
    new_state = scan_drop_folder(state)
    {:reply, length(new_state[:files]), new_state}
  end

  def handle_call(:scan, _from, state), do: {:reply, 0, state}

  defp scan_drop_folder(%{scanned_folder: path} = state) do
    file_lst = state[:files] ++ Path.wildcard("#{path}/**/*.JPG")

    stf =
      Map.merge(state, %{
        files: file_lst,
        scanned: true
      })

    LoudCounter.increment_tag(:total, Enum.count(file_lst))
    stf
  end

  defp start_data do
    %{
      files: [],
      scanned: false,
      scanned_folder: Application.get_env(:photo_flow_example, PhotoFlowExample)[:scanned_folder]
    }
  end
end
