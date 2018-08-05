// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

@R2     // Init R2 to 0
M=0
@i      // Init i = 1
M=1

@R1     // If R1 > R0, then Add R1 into R2 R0 times, else Add R0 into R2 R1 times
D=M
@R0
D=D-M   // R1 - R0
@R1GREATER
D;JGT
@R0GREATER
D;JMP

(R0GREATER)
(LOOPR0)  // Add R0 into R2 R1 times
@i      // Load i into D
D=M
@R1     // if (i - R1) > 0 then goto end
D=D-M
@END
D;JGT
@R0     // load R0 into D
D=M
@R2     // Add R0 into R2 1 time
M=M+D
@i      // Increment i
M=M+1
@LOOPR0
0;JMP

(R1GREATER)
(LOOPR1)  // Add R1 into R2 R0 times
@i      // Load i into D
D=M
@R0     // if (i - R0) > 0 then goto end
D=D-M
@END
D;JGT
@R1     // load R1 into D
D=M
@R2     // Add R1 into R2 1 time
M=M+D
@i      // Increment i
M=M+1
@LOOPR1
0;JMP

(END)
@END
0;JMP
