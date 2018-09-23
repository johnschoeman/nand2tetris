// --- push constant x
//
// @x
// D=A
// @SP
// A=M
// M=D
// @SP
// M=M+1
//
// --- add
//
// @SP
// M=M-1
// A=M
// D=M
// A=A-1
// M=M+D
//
// --- eq

@SP    // eq
A=M-1
D=M    // D = RAM[SP-1]
A=A-1
D=D-M  // RAM[SP-1] - RAM[SP-2]
@IS_TRUE
D;JEQ

@SP    // set RAM[SP-2] to 0
D=M-1
D=D-1
A=D
M=0
@END
0;JMP

(IS_TRUE)
@SP    // set RAM[SP-2] to -1
D=M-1
D=D-1
A=D
M=-1

(END)
@SP
M=M-1

// eq
SP--
D=*SP
SP--
D=D-*SP
@IS_TRUE.suffix
D;JEQ
*SP=false
@END.suffix
0;JMP
(IS_TRUE.suffix)
*SP=true
(END)
SP++

//SP--
@SP
M=M-1

//SP++
@SP
M=M+1

//D=D-*SP
@SP
A=M
D=D-M

//D=*SP
@SP
A=M
D=M

//*SP=false
@SP
A=M
M=false

//*SEG=x
@SEG
A=M
M=x

// A=LCL+i
@i
D=A
@LCL
A=D+M

