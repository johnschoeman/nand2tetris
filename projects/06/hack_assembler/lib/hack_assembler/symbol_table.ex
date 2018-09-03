defmodule SymbolTable do
  use GenServer

  # Client
  def start_link do
    initial_table = %{
      "@SP\n" => 0,
      "@LCL\n" => 1,
      "@ARG\n" => 2,
      "@THIS\n" => 3,
      "@THAT\n" => 4,
      "@R0\n" => 0,
      "@R1\n" => 1,
      "@R2\n" => 2,
      "@R3\n" => 3,
      "@R4\n" => 4,
      "@R5\n" => 5,
      "@R6\n" => 6,
      "@R7\n" => 7,
      "@R8\n" => 8,
      "@R9\n" => 9,
      "@R10\n" => 10,
      "@R11\n" => 11,
      "@R12\n" => 12,
      "@R13\n" => 13,
      "@R14\n" => 14,
      "@R15\n" => 15,
      "@SCREEN\n" => 16384,
      "@KBD\n" => 24576
    }

    start_link(initial_table)
  end

  def start_link(map, opts \\ []) when is_map(map) do
    GenServer.start_link(__MODULE__, map, opts)
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def put_new(pid, key, value) do
    GenServer.call(pid, {:put_new, key, value})
  end

  # Server

  @impl true
  def init(initial_state) do
    {:ok, initial_state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    value = Map.get(state, key)
    {:reply, value, state}
  end

  @impl true
  def handle_call({:put_new, key, value}, _from, state) do
    result = Map.put_new(state, key, value)
    {:reply, result, result}
  end
end
