defmodule Ouija.PeriodicWorkerTest do
  use ExSpec

  alias Ouija.PeriodicWorker

  it "can be started and stopped" do
    assert {:ok, pid} = PeriodicWorker.start_link( &id/1, :ok, 10_000 )
    assert pid |> Process.alive?
    PeriodicWorker.stop( pid )
    :timer.sleep 2
    refute pid |> Process.alive?
  end

  it "periodically sends the results to the parent process" do
    {:ok, pid} = PeriodicWorker.start_link( &inc/1, 0, 10 )
    refute_receive _, 9
    assert_receive 1, 2
    assert_receive 2, 11
    assert_receive 3, 11
    assert_receive 4, 11
    PeriodicWorker.stop( pid )
  end

  def id(x),  do: x
  def inc(n), do: n + 1
end
