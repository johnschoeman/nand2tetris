defmodule HackPretranslator do
  def pretranslate(file) do
    {:ok, symbol_table_pid} = SymbolTable.start_link
    {:ok, addr_counter_pid} = Counter.start_link(16)
    {:ok, line_number_counter_pid} = Counter.start_link(0)

    file
    |> Enum.map(&remove_unused_characters(&1, line_number_counter_pid))
    |> Enum.map(&note_labels(&1, symbol_table_pid, line_number_counter_pid))
    |> Enum.map(&note_symbols(&1, symbol_table_pid, addr_counter_pid))
    |> Enum.map(&replace_symbols(&1, symbol_table_pid))
  end

  defp remove_unused_characters(line, line_number_counter_pid) do
    line
      |> remove_comments
      |> remove_spaces
      |> remove_blank_lines(line_number_counter_pid)
  end

  defp remove_comments(line) do
    String.replace(line, ~r/\/\/.*/, "")
  end

  defp remove_spaces(line) do
    String.replace(line, " ", "")
  end

  defp remove_blank_lines(line, line_number_counter_pid) do
    if String.match?(line, ~r/^\n/) do
      Counter.decrement(line_number_counter_pid)
      ""
    else
      line
    end
  end

  defp note_labels(line, symbol_table_pid, line_number_counter_pid) do
    if is_a_label(line) do
      note_label(line, symbol_table_pid, line_number_counter_pid)
     ""
    else
      Counter.increment(line_number_counter_pid)
      line
    end
  end

  defp is_a_label(line) do
    Regex.match?(~r/^\(.+\)$/, line)
  end

  defp note_label(line, symbol_table_pid, line_number_counter_pid) do
    a_inst_for_label = "@" <> Regex.replace(~r/\(|\)/, line, "")
    line_number = Counter.state(line_number_counter_pid)
    SymbolTable.put_new(symbol_table_pid, a_inst_for_label, line_number)
  end

  defp note_symbols(line, symbol_table_pid, addr_counter_pid) do
    if is_a_symbol(line) do
      note_symbol(line, symbol_table_pid, addr_counter_pid)
    end
    line
  end

  defp is_a_symbol(line) do
    Regex.match?(~r/^@\D+/, line)
  end

  defp note_symbol(line, symbol_table_pid, addr_counter_pid) do
    if !SymbolTable.get(symbol_table_pid, line) do
      addr = Counter.increment(addr_counter_pid)
      SymbolTable.put_new(symbol_table_pid, line, addr)
    end
    line
  end

  defp replace_symbols(line, symbol_table_pid) do
    if is_a_symbol(line) do
      addr = SymbolTable.get(symbol_table_pid, line)
      "@" <> Integer.to_string(addr)
    else
      line
    end
  end
end
