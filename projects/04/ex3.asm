// goto 50
@50
0;JMP

// if D==0 goto 112
@112
D;JEQ

// if D<9 goto 507
@9
D=D-A
@507
D;JLT

// if RAM[12] > 0 goto 50
@12
D=M
@50
D;JGT

// if sum > 0 goto END
@sum
D=M
@END
D;JGT
(END)

// if x[i]<=0 goto NEXT
// ???
