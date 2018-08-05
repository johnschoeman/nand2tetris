// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.


(STARTWHITE) // Initialize screen index for whiteloop
@SCREEN      // set @screen to 0x4000
D=A
@screen
M=D
@WHITELOOP   // goto whiteloop
0;JMP

(STARTBLACK) // Initialize screen index for blackloop
@SCREEN      // set @screen to 0x4000
D=A
@screen
M=D
@BLACKLOOP   //goto black loop
0;JMP

(WHITELOOP)  // START WHITELOOP
@KBD       // If key press goto blackloop
D=M
@STARTBLACK
D;JNE

@screen      // if at end of screen, then stop filling
D=M
@24576       // last screen address is RAM[24576]
D=D-A
@SKIPWHITEFILL
D;JEQ

@screen      // set screen to 0
A=M
M=0

@screen      // screen++
D=M
@1
D=D+A
@screen
M=D

(SKIPWHITEFILL)
@WHITELOOP
0;JMP       // END WHITELOOP


(BLACKLOOP) // START BLACK LOOP
@KBD        // if no key press goto whiteloop
D=M
@STARTWHITE
D;JEQ

@screen    // check if at end of screen
D=M
@24576       // last screen address is RAM[24576]
D=D-A
@SKIPBLACKFILL
D;JEQ

@screen   // set screen to -1
A=M
M=-1

@screen   // screen++
D=M
@1
D=D+A
@screen
M=D

(SKIPBLACKFILL)
@BLACKLOOP
0;JMP    // END BLACKLOOP

