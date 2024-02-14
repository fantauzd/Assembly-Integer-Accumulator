TITLE Integer Accumulator     (Project3_fantauzd.asm)

; Author:  Dominic Fantauzzo
; Last Modified:  10/29/2023
; OSU email address:  fantauzd@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number:      Project 3           Due Date: 10/30/2023
; Description: Program asks the user to enter negative numbers and then enter a non-negative number to stop. 
;		Program then returns the minimum, maximum, average value, total sum, and total 
;		number statistics of the user's valid inputs. 

INCLUDE Irvine32.inc

LIMITA = -200
LIMITB = -100
LIMITC = -50
LIMITD = -1

.data
	introduction	BYTE "Welcome to the Integer Accumulator by Dominic Fantauzzo",13,10,0
	description		BYTE "You will be asked to input negative integers between specified bounds.",13,10,"We will be accumulating these integers to display the minimum, maximum, average value, total sum, and total number statistics of your valid inputs.",13,10,0
	namePrompt		BYTE "What is your name? ",0
	nameInput		BYTE 25 DUP(0)
	greeting		BYTE "Well, hello ",0
	introPrompt		BYTE "Please enter numbers in [-200, -100] or [-50, -1].",13,10,0,"Enter a non-negative number when you are done, and your statistics will be shown.",13,10,0
	numberPrompt	BYTE "Enter a number: ",0
	invalidInput	BYTE "This number is not acceptable (Invalid Input)!",13,10,0
	countStart		Byte "You entered ",0
	countEnd		Byte " valid numbers.",13,10,0
	noValid			Byte "Since you never entered a valid number, I dont have any statistics to report!",13,10,0
	maxStart		Byte "The maximum valid number is: ",0
	minStart		BYTE "The minimum valid number is: ",0
	sumStart		BYTE "The sum of your valid numbers is: ",0
	avgStart		Byte "The rounded average is: ",0
	goodbye			BYTE "It was a pleasure computing for you. Bye ",0
	min				SDWORD -1
	max				SDWORD -200
	count			DWORD 0
	sum				SDWORD 0
	average			SDWORD ?
	remainder		SDWORD ?

.code
main PROC

	; display the program title and programer's name
	MOV		EDX, OFFSET introduction
	CALL	WriteString
	
	; display a program description
	MOV		EDX, OFFSET description
	CALL	WriteString

	; get the user's name
	MOV		EDX, OFFSET namePrompt
	CALL	WriteString
	MOV		EDX, OFFSET nameInput			; Preconditions of Readstring: (1) Max length saved in ECX, EDX holds pointer to string
	MOV		ECX, 24
	CALL	ReadString

	; greet the user
	MOV		EDX, OFFSET greeting
	CALL	WriteString
	MOV		EDX, OFFSET nameInput
	CALL	WriteString
	Call	CrLf

	; display instructions
	MOV		EDX, OFFSET introPrompt
	Call	WriteString

	; repeatedly prompt the user to enter a number
_NumInput:
	MOV		EDX, OFFSET numberPrompt
	CALL	WriteString
	CALL	ReadInt

	; Detect a non-negative input using sign flag, discard non-negative and invalid numbers
	CMP		EAX, 0
	JGE		_Return

	; validate user input to be in [-200,-100] or [-50,-1] inclusive
	CMP		EAX, LIMITA
	JL		_NumInvalid
	CMP		EAX, LIMITB
	JLE		_Count
	CMP		EAX, LIMITC
	JL		_NumInvalid
	JMP		_Count

	; notify the user of any invalid negative numbers
_NumInvalid:
	MOV		EDX, OFFSET invalidInput
	CALL	WriteString
	JMP		_NumInput

	; Count and accumulate the valid user numbers until a non-negative number is entered.
_Count:
	INC		count
	ADD		SUM, EAX
	CMP		EAX, min
	JL		_MinWrite
	CMP		EAX, max
	JG		_MaxWrite
	JMP		_NumInput
_MinWrite:
	MOV		min, EAX
	CMP		EAX, max
	JG		_MaxWrite
	JMP		_NumInput
_MaxWrite:
	MOV		max, EAX
	JMP		_NumInput

	; calculate and store the rounded averge of the valid numbers
_Return:
	MOV		EAX, count                   
	CMP		EAX, 0
	JNA		_NoValidEntry               ; handles invalid entry 
	MOV		EAX, 0
	MOV		EAX, sum 
	CDQ
	IDIV	count
	MOV		remainder, EDX			                   
	MOV		average, EAX				
	MOV		EAX, 0
	MOV		EAX, remainder
	MOV		EBX, 10
	IMUL	EBX                         ; remainder is negative so we use IMUL
	IDIV	count                       
	CMP		EAX, -5                     ; if (remainder x 10) / divisor < -5 then we need to round down (-1.51 to -2, -1.5 to -1)
	JL		_RoundDown                  ; if operand1 is below operand2 then we should round
	JE		_CheckHundreds				; if operand1 = operand 2 then we have a .5? remainder. We need to check if it is .50 
	JMP		_Display
_CheckHundreds:
	CMP		EDX, 0						; take remainder of remainder and CMP with 0. 
	JL		_RoundDown					; if not 0 then original remainder is -.51 or less (we should round down)
	JMP		_Display
_RoundDown:
	MOV		EAX, average
	SUB		EAX, 1
	MOV		average, EAX
	JMP		_Display

	; display special message if no valid numbers were entered
_NoValidEntry:
	MOV		EDX, OFFSET noValid
	Call	WriteString
	JMP		_farewell

	; display the count of valid numbers
_Display:
	MOV		EDX, OFFSET countStart
	CALL	WriteString
	MOV		EAX, count
	CALL	WriteDec
	MOV		EDX, OFFSET countEnd
	CALL	WriteString

	; display the sum of the valid numbers
	MOV		EDX, OFFSET sumStart
	CALL	WriteString
	MOV		EAX, sum
	CALL	WriteInt
	CALL	CrLf

	; display the maximum (closest to 0) valid input
	MOV		EDX, OFFSET maxStart
	CALL	WriteString
	MOV		EAX, max
	CALL	WriteInt
	CALL	CrLf

	; display the minimum (farthest from 0) valid input
	MOV		EDX, OFFSET minStart
	CALL	WriteString
	MOV		EAX, min
	CALL	WriteInt
	CALL	CrLf

	; display the average to the nearest integer
	MOV		EDX, OFFSET avgStart
	CALL	WriteString
	MOV		EAX, average
	CALL	WriteInt
	CALL	CrLf

	; display a parting message
_farewell:
	MOV		EDX, OFFSET goodbye
	CALL	WriteString
	MOV		EDX, OFFSET nameInput
	CALL	WriteString
	CALL	CrLf

	Invoke ExitProcess,0	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
