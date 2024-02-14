Program Description
Write and test a MASM program to perform the following tasks:

Display the program title and programmer’s name.
Get the user's name, and greet the user.
Display instructions for the user.
Repeatedly prompt the user to enter a number.
Validate the user input to be in [-200, -100] or [-50, -1] (inclusive).
Notify the user of any invalid negative numbers (negative, but not in the ranges specified)
Count and accumulate the valid user numbers until a non-negative number is entered. Detect this using the SIGN flag.
(The non-negative number and any numbers not in the specified ranges are discarded.)
Calculate the (rounded integer) average of the valid numbers and store in a variable.
Display:
the count of validated numbers entered
NOTE: if no valid numbers were entered, display a special message and skip to (f)
the sum of valid numbers
the maximum (closest to 0) valid user value entered
the minimum (farthest from 0) valid user value entered
the average, rounded to the nearest integer
-20.01 rounds to -20
-20.5 rounds to -20
-20.51 rounds to -21
-20.99 rounds to -21
a parting message (with the user’s name)
Program Requirements
The program must be fully documented and laid out according to the CS271 Style Guide. This includes a complete header block for identification, description, etc., section comments for logical sections of code (modules) and block comments for code blocks.
The main procedure must be modularized into commented logical sections (procedures are not required this time)
The four value limits must be defined as constants.
The user input loop should terminate depending on the value of the SIGN flag.
The Min, Max, Count, Sum, and
