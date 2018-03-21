defmodule PhotoFlowExample.LoudCounter do
  use GenServer

  def start_link(_data) do
    GenServer.start_link(__MODULE__, start_data(), name: PhotoFlowExample.LoudCounter)
  end

  def increment_tag(tag, amt) do
    GenServer.call(PhotoFlowExample.LoudCounter, {:set_tag, tag, amt})
  end

  def tags do
    GenServer.call(PhotoFlowExample.LoudCounter, :tags)
  end

  def history do
    GenServer.call(PhotoFlowExample.LoudCounter, :history)
  end

  def different_tags do
    GenServer.call(PhotoFlowExample.LoudCounter, :different_tags)
  end

  def reset() do
    GenServer.call(PhotoFlowExample.LoudCounter, {:reset, 0})
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:history, _from, data) do
    {:reply, data[:history], data}
  end

  def handle_call(:tags, _from, data) do
    {:reply, data[:tags], data}
  end

  def handle_call(:different_tags, _from, data) do
    if Map.equal?(data[:tags], data[:last_tags]) do
      {:reply, %{}, data}
    else
      {:reply, data[:tags],
       data
       |> Map.put(:last_tags, data[:tags])
       |> Map.put(:history, [timestamp(data[:tags]) | data[:history]])}
    end
  end

  def handle_call(:reset, _from, _data) do
    data = start_data()
    {:reply, data, data}
  end

  def handle_call({:set_tag, tag, amt}, _from, data) do
    data = Map.put(data, :tags, bump_key(data[:tags], tag, amt))

    {:reply, data[:tags], data}
  end

  defp timestamp(dt) do
    Map.put(dt, :time, :os.system_time(:milli_seconds))
  end

  defp bump_key(data, key, inc) do
    {_, news} =
      Map.get_and_update(data, key, fn prev_val ->
        case prev_val do
          nil ->
            {prev_val, inc}

          val ->
            {val, val + inc}
        end
      end)

    news
  end

  defp start_data do
    %{
      current_day: "",
      last_tags: %{},
      history: [],
      tags: %{}
    }
  end
end
