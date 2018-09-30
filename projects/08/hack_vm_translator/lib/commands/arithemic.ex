  defmodule Commands.Arithmetic do
    def add do
      add_base("+")
    end

    def sub do
      add_base("-")
    end

    def and_command do
      add_base("&")
    end

    def or_command do
      add_base("|")
    end

    defp add_base(type) do
      ~s"""
      @SP
      M=M-1
      A=M
      D=M
      A=A-1
      M=M#{type}D
      """
    end

    def eq(count) do
      eq_base("JEQ", count)
    end

    def lt(count) do
      eq_base("JLT", count)
    end

    def gt(count) do
      eq_base("JGT", count)
    end

    defp eq_base(type, count) do
      ~s"""
      @SP
      M=M-1
      @SP
      A=M
      D=M
      @SP
      M=M-1
      @SP
      A=M
      D=M-D
      @IS_TRUE_#{count}
      D;#{type}
      @SP
      A=M
      M=0
      @END_#{count}
      0;JMP
      (IS_TRUE_#{count})
      @SP
      A=M
      M=-1
      (END_#{count})
      @SP
      M=M+1
      """
    end

    def neg do
      ~s"""
      @SP
      A=M-1
      M=-M
      """
    end

    def not_command do
      ~s"""
      @SP
      A=M-1
      M=!M
      """
    end
  end
