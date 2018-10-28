defmodule Counter do
  use GenServer

  # Client

  def start_link do
    start_link(0)
  end

  def start_link(integer, opts \\ []) when is_integer(integer)  do
    GenServer.start_link(__MODULE__, integer, opts)
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  def increment(pid) do
    GenServer.call(pid, :increment)
  end

  def decrement(pid) do
    GenServer.call(pid, :decrement)
  end

  # Server

  @impl true
  def init(initial_count) do
    {:ok, initial_count}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call(:increment, _from, state) do
    result = state + 1
    {:reply, result, result}
  end

  @impl true
  def handle_call(:decrement, _from, state) do
    result = state - 1
    {:reply, result, result}
  end
end
