defmodule CLI do
  def main(args \\ []) do
    args
    |> List.first
    |> Translator.translate
  end
end
