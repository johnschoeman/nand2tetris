defmodule Assembler do
  @moduledoc """
  An assembler for the hack machine language
  """

  @doc """
    iex> HackAssembler.assemble Prog.asm
    Prog.hack
  """

  def assemble(program_path) do
    hack_file_path = create_hack_file_path(program_path)

    File.stream!(program_path)
    |> HackPretranslator.pretranslate
    |> HackTranslator.translate
    |> Stream.into(File.stream!(hack_file_path))
    |> Stream.run()
  end

  defp create_hack_file_path(path) do
    String.replace_trailing(path, ".asm", ".hack")
  end
end
