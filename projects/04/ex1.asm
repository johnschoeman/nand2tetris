// set D to A - 1
0
@value
D=A-1

// set both A and D to A + 1
0
@value
AD=A+1

// set D to 19
@19
D=A

// set both A and D to A + D
0
@value
AD=A+D

// set RAM[5034] to D-1
@5034
M=D-1

// set RAM[53] to 171
@171
D=A
@53
M=D

// add 1 to RAM[7] and store result in D
@7
D=M
D=D+1
