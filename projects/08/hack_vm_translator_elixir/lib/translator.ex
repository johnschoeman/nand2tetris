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
    case command_type(line) do
      :COMMENT ->
        remove_comment()
      :C_PROGRAM_FLOW ->
        translate_program_flow(line)
      :C_FUNCTION ->
        translate_function_call(line)
      :C_MEMORY ->
        translate_memory_management(line, file_name)
      :C_ARITHMETIC ->
        translate_arithmetic(line)
      :C_COMPARISON ->
        translate_comparison(line, counter_pid)
      _ ->
        IO.puts "UNKNOWN COMMAND: '#{line}'"
    end
  end

  defp command_type(line) do
    cond do
      String.match?(line, ~r/^\/\/|^\n/) ->
        :COMMENT
      String.match?(line, ~r/label|if-goto|goto/) ->
        :C_PROGRAM_FLOW
      String.match?(line, ~r/push|pop/) ->
        :C_MEMORY
      String.match?(line, ~r/function|call|return/) ->
        :C_FUNCTION
      String.match?(line, ~r/add|sub|and|or|not|neg/) ->
        :C_ARITHMETIC
      String.match?(line, ~r/eq|gt|lt/) ->
        :C_COMPARISON
    end
  end

  defp remove_comment() do
    ""
  end

  defp translate_arithmetic(line) do
    case parse_command(line) do
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
    end
  end

  defp translate_comparison(line, counter_pid) do
    count = Counter.increment(counter_pid)
    case parse_command(line) do
      ["eq" | _tail] ->
        Commands.Arithmetic.eq(count)
      ["lt" | _tail] ->
        Commands.Arithmetic.lt(count)
      ["gt" | _tail] ->
        Commands.Arithmetic.gt(count)
    end
  end

  defp translate_memory_management(line, file_name) do
    case parse_command(line) do
      ["push", "static", x | _tail] ->
        Commands.Memory.push_static(file_name, x)
      ["pop", "static", x | _tail] ->
        Commands.Memory.pop_static(file_name, x)
      ["push", segment, x | _tail] ->
        Commands.Memory.push_segment(segment, x)
      ["pop", segment, x | _tail] ->
        Commands.Memory.pop_segment(segment, x)
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

  defp translate_function_call(line) do
    case parse_command(line) do
      ["function", function_name, num_vars | _tail ] ->
        Commands.FunctionCall.function(function_name, num_vars)
      ["call", function_name, num_args | _tail] ->
        Commands.FunctionCall.call(function_name, num_args)
      ["return" | _tail] ->
        Commands.FunctionCall.return()
    end
  end

  defp parse_command(line) do
    line
    |> String.trim
    |> String.split(" ")
  end
end
