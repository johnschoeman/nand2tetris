  defmodule Commands.ProgramFlow do
    def label(label) do
      ~s"""
      (#{label})
      """
    end

    def goto(label) do
      ~s"""
      // goto #{label}
      @#{label}
      0;JMP
      """
    end

    def if_goto(label) do
      # SP--
      # D=*SP
      # @LABEL
      # D;JNE
      ~s"""
      // if-goto #{label}
      @SP
      AM=M-1
      D=M
      @#{label}
      D;JNE
      """
    end
  end
