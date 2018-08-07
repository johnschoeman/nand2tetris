//if condition {
//  codeblock1 }
//else {
//  codeblock2 }
//codeblock3

D
@IF_TRUE
D;JEQ
@2
M=-1
@END
0;JMP
(IF_TRUE)
@1
M=1
(END)
@0
M=1
