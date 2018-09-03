defmodule HackTranslator do
  @moduledoc """
  Translates a single line of assembly to machine code.
  """

  @dest_map %{
    "" => "000",
    "M" => "001",
    "D" => "010",
    "MD" => "011",
    "A" => "100",
    "AM" => "101",
    "AD" => "110",
    "AMD" => "111"
  }

  @comp_map %{
    "0" => "0101010",
    "1" => "0111111",
    "-1" => "0111010",
    "D" => "0001100",
    "A" => "0110000",
    "!D" => "001101",
    "!A" => "0110001",
    "-D" => "0001111",
    "-A" => "0110011",
    "D+1" => "0011111",
    "A+1" => "0110111",
    "D-1" => "0001110",
    "A-1" => "0110010",
    "D+A" => "0000010",
    "D-A" => "0010011",
    "A-D" => "0000111",
    "D&A" => "0000000",
    "D|A" => "0010101",
    "M" => "1110000",
    "!M" => "1110001",
    "-M" => "1110011",
    "M+1" => "1110111",
    "M-1" => "1110010",
    "D+M" => "1000010",
    "D-M" => "1010011",
    "M-D" => "1000111",
    "D&M" => "1000000",
    "D|M" => "1010101"
  }

  @jump_map %{
    "" => "000",
    "JGT" => "001",
    "JEQ" => "010",
    "JGE" => "011",
    "JLT" => "100",
    "JNE" => "101",
    "JLE" => "110",
    "JMP" => "111"
  }

  def translate(file) do
    file
    |> Stream.map(&translate_line(&1))
  end

  defp translate_line(line) do
    cond do
      is_a_inst(line) ->
        translate_a_inst(line)
      is_c_inst(line) ->
        translate_c_inst(line)
      true ->
        line
    end
  end

  def is_a_inst(line) do
    String.first(line) == "@"
  end

  defp is_c_inst(line) do
    String.length(line) != 0
  end

  defp translate_a_inst(line) do
    line
      |> String.replace("@", "")
      |> String.trim
      |> String.to_integer
      |> Integer.to_string(2)
      |> String.pad_leading(16, "0")
      |> make_16bit
      |> add_new_line
  end

  defp make_16bit(string) do
    if String.length(string) do
      string
        |> String.graphemes
        |> Enum.take(-16)
        |> Enum.join
    else
      string
    end
  end

  defp add_new_line(string) do
    string <> "\n"
  end

  defp translate_c_inst(line) do
    [dest, comp, jump] = parse_c_inst(line)
    dest_code = @dest_map[dest]
    comp_code = @comp_map[comp]
    jump_code = @jump_map[jump]

    "111" <> comp_code <> dest_code <> jump_code <> "\n"
  end

  defp parse_c_inst(string) do
    string
    |> prepend_equals
    |> append_semi_colon
    |> String.split(["=", ";"])
    |> Enum.map(&String.trim(&1))
  end

  defp prepend_equals(string) do
    if String.match?(string, ~r/=/) do
      string
    else
      "=" <> string
    end
  end

  defp append_semi_colon(string) do
    if String.match?(string, ~r/;/) do
      string
    else
      string <> ";"
    end
  end
end
