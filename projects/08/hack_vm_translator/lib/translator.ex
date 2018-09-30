defmodule Translator do
  def translate(program_path) do
    hack_file_path = create_hack_file_path(program_path)
    file_name = get_file_name(program_path)

    {:ok, counter_pid} = Counter.start_link(0)

    File.stream!(program_path)
    |> Stream.map(&translate_line(&1, file_name, counter_pid))
    |> Stream.into(File.stream!(hack_file_path))
    |> Stream.run()
  end

  defp create_hack_file_path(path) do
    String.replace_trailing(path, ".vm", ".asm")
  end

  defp get_file_name(program_path) do
    program_path
    |> String.split("/")
    |> List.last
    |> String.replace_trailing(".vm", "")
  end

  defp translate_line(line, file_name, counter_pid) do
    IO.puts(line)
    cond do
      is_a_comment?(line) ->
        ""
      is_program_flow?(line) ->
        translate_program_flow(line)
      true ->
        Counter.increment(counter_pid)
        replace_with_assembly(line, file_name, counter_pid)
    end
  end

  defp is_a_comment?(line) do
    String.match?(line, ~r/^\/\//) || String.match?(line, ~r/^\n/)
  end

  defp is_program_flow?(line) do
    String.match?(line, ~r/label|if-goto|goto/)
  end

  defp replace_with_assembly(line, file_name, counter_pid) do
    count = Counter.state(counter_pid)
    case parse_command(line) do
      ["push", "static", x | _tail] ->
        Commands.Memory.push_static(file_name, x)
      ["pop", "static", x | _tail] ->
        Commands.Memory.pop_static(file_name, x)
      ["push", segment, x | _tail] ->
        Commands.Memory.push_segment(segment, x)
      ["pop", segment, x | _tail] ->
        Commands.Memory.pop_segment(segment, x)
      ["add" | _tail] ->
        Commands.Arithmetic.add()
      ["sub" | _tail] ->
        Commands.Arithmetic.sub()
      ["and" | _tail] ->
        Commands.Arithmetic.and_command()
      ["or" | _tail] ->
        Commands.Arithmetic.or_command()
      ["not" | _tail] ->
        Commands.Arithmetic.not_command()
      ["neg" | _tail] ->
        Commands.Arithmetic.neg()
      ["eq" | _tail] ->
        Commands.Arithmetic.eq(count)
      ["lt" | _tail] ->
        Commands.Arithmetic.lt(count)
      ["gt" | _tail] ->
        Commands.Arithmetic.gt(count)
      _ ->
        IO.puts "UNKNOWN COMMAND: #{line}"
    end
  end

  defp translate_program_flow(line) do
    case parse_command(line) do
      ["label", label | _tail] ->
        Commands.ProgramFlow.label(label)
      ["if-goto", label | _tail] ->
        Commands.ProgramFlow.if_goto(label)
      ["goto", label | _tail] ->
        Commands.ProgramFlow.goto(label)
    end
  end

  defp parse_command(line) do
    line
    |> String.trim
    |> String.split(" ")
  end
end
