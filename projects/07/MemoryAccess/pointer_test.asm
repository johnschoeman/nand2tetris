// push constant 11
@11
D=A
@SP
A=M
M=D
@SP
M=M+1
// push constant 13
@13
D=A
@SP
A=M
M=D
@SP
M=M+1
// pop pointer 0
@SP
AM=M-1
D=M
@THIS
M=D
// pop pointer 1
@SP
AM=M-1
D=M
@THAT
M=D
