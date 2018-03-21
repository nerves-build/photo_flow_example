defmodule PhotoFlowExampleWeb.PhotoFlowChannel do
  use PhotoFlowExampleWeb, :channel
  alias PhotoFlowExample.LoudCounter
  alias PhotoFlowExample.Locations

  def shout do
    Process.send(self(), :shout, [])
  end

  def join("photo_flow:live", _payload, socket) do
    Process.send(self(), :start_shouting, [])
    {:ok, broadcast_format(LoudCounter.tags()), socket}
  end

  def handle_in("start_load", _payload, socket) do
    spawn_link(fn ->
      PhotoFlowExample.Flows.Flow.start_flow()
    end)

    {:noreply, socket}
  end

  def handle_info(:shout, socket) do
    broadcast_tags(socket, LoudCounter.tags())
    {:noreply, socket}
  end

  def handle_info(:start_shouting, socket) do
    broadcast_tags(socket, LoudCounter.different_tags())

    Process.send_after(self(), :start_shouting, 1000)
    {:noreply, socket}
  end

  defp broadcast_tags(_socket, tags) when tags == %{}, do: :ok

  defp broadcast_tags(socket, tags) do
    broadcast!(socket, "refresh", broadcast_format(tags))
  end

  defp broadcast_format(tags) do
    %{
      status: tags,
      history: LoudCounter.history(),
      places: Locations.list_places() |> Enum.map(fn p -> %{id: p.id, name: p.name} end)
    }
  end
end
