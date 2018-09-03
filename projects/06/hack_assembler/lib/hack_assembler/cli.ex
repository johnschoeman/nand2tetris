defmodule HackAssembler.CLI do
  def main(args \\ []) do
    args
    |> List.first
    |> Assembler.assemble
  end
end
