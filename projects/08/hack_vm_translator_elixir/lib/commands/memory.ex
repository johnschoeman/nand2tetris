  defmodule Commands.Memory do
    def push_static(file_name, i) do
      # @f.i
      # D=M
      # *SP=D
      # SP++
      ~s"""
      // push static #{i}
      @#{file_name}.#{i}
      D=M
      @SP
      A=M
      M=D
      @SP
      M=M+1
      """
    end

    def push_segment("constant", i) do
      ~s"""
      // push constant #{i}
      @#{i}
      D=A
      @SP
      A=M
      M=D
      @SP
      M=M+1
      """
    end

    def push_segment("temp", i) do
      # A=5+i
      # D=M
      # *SP=D
      # SP++

      temp_addr = String.to_integer(i) + 5
      ~s"""
      // push temp #{i}
      @#{temp_addr}
      D=M
      @SP
      A=M
      M=D
      @SP
      M=M+1
      """
    end

    def push_segment("pointer", i) do
      # A=3+i
      # D=M
      # *SP=D
      # SP++

      pointer_addr = String.to_integer(i) + 3
      ~s"""
      // push pointer #{i}
      @#{pointer_addr}
      D=M
      @SP
      A=M
      M=D
      @SP
      M=M+1
      """
    end

    def push_segment("local", i) do
      push_segment_base("LCL", i)
    end

    def push_segment("argument", i) do
      push_segment_base("ARG", i)
    end

    def push_segment("this", i) do
      push_segment_base("THIS", i)
    end

    def push_segment("that", i) do
      push_segment_base("THAT", i)
    end

    def push_segment_base(segment, i) do
      # A=Segment+i
      # D=M
      # *SP=D
      # SP++

      ~s"""
      // push #{segment} #{i}
      @#{i}
      D=A
      @#{segment}
      A=D+M
      D=M
      @SP
      A=M
      M=D
      @SP
      M=M+1
      """
    end

    def pop_static(file_name, i) do
      # SP--
      # D = *SP
      # @f.i
      # M = D
      ~s"""
      @SP
      M=M-1
      @SP
      A=M
      D=M
      @#{file_name}.#{i}
      M=D
      """
    end

    def pop_segment("temp", i) do
      # @i // @(5 + i)
      # D=A
      # @5
      # R13=D+A
      # R13=5+i
      # SP--
      # D=*SP
      # *R13=D
      ~s"""
      // pop temp #{i}
      @#{i}
      D=A
      @5
      D=D+A
      @R13
      M=D
      @SP
      AM=M-1
      D=M
      @R13
      A=M
      M=D
      """
    end

    def pop_segment("pointer", "0") do
      # SP--
      # D=*SP
      # THIS=D
      ~s"""
      // pop pointer 0
      @SP
      AM=M-1
      D=M
      @THIS
      M=D
      """
    end

    def pop_segment("pointer", "1") do
      # SP--
      # D=*SP
      # THAT=D
      ~s"""
      // pop pointer 1
      @SP
      AM=M-1
      D=M
      @THAT
      M=D
      """
    end

    def pop_segment("local", i) do
      pop_segment_base("LCL", i)
    end

    def pop_segment("argument", i) do
      pop_segment_base("ARG", i)
    end

    def pop_segment("this", i) do
      pop_segment_base("THIS", i)
    end

    def pop_segment("that", i) do
      pop_segment_base("THAT", i)
    end

    defp pop_segment_base(segment, i) do
      # R13=Seg+i
      # SP--
      # D=*SP
      # *R13=D
      ~s"""
      // pop #{segment} #{i}
      @#{segment}
      D=M
      @#{i}
      D=D+A
      @R13
      M=D
      @SP
      M=M-1
      A=M
      D=M
      @R13
      A=M
      M=D
      """
    end
  end
