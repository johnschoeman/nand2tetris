// sum = 0
@sum
M=0

// j = j + 1
@j
D=M
M=D+1

// q = sum + 12 - j
@sum
D=M
@12
D=D+A
@j
D=D-M
@q
M=D

// arr[3] = -1
@arr
D=A
@3
A=D+A
M=-1

// arr[j] = 0
@j
D=M
@arr
A=D+A
M=0


// arr[j] = 17
@j
D=M
@arr
D=D+A
@arrj
M=D
@17
D=A
@arrj
M=D
