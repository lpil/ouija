defmodule Ouija.PeriodicWorker do
  @moduledoc """
  Calls a function every X miliseconds, sending the result to the parent.

  The result of the work function is stored, and used as the argument to the
  worker function the next time it runs.
  """

  use GenServer

  defstruct work_fn:  nil,
            parent:   nil,
            state:    nil,
            interval: 10_000

  alias Ouija.PeriodicWorker, as: PW

  @type work_fn :: (any -> any)


  @doc """
  Starts a PeriodicWorker process.
  """
  @spec start_link(work_fn, any, pos_integer) :: tuple
  def start_link(function, state, interval) do
    data = %PW{
      work_fn:  function,
      parent:   self,
      state:    state,
      interval: interval,
    }
    GenServer.start_link( __MODULE__, data )
  end


  @doc """
  Stops a PeriodicWorker process.
  """
  @spec stop(pid) :: :ok
  def stop(pid) do
    GenServer.call( pid, :stop )
  end



  @spec init(%PW{}) :: {:ok, %PW{}}
  def init(data) do
    schedule_work( data.interval )
    {:ok, data}
  end

  def handle_info(:work, data) do
    state = data.work_fn.( data.state )
    data  = %PW{ data | state: state }
    data.parent |> send( state )
    schedule_work( data.interval )
    {:noreply, data}
  end

  def handle_call(:stop, _from, _state) do
    {:stop, :normal, :ok, []}
  end


  defp schedule_work(interval) do
    Process.send_after(self, :work, interval)
  end
end
