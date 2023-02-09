# MIPS Basics
# CSC 211
# Play a Song with MIDI+MIPS
# Data section and original code to play the opening line by Jerod Weinman
.data
	# The following are MIDI-coded tones for Beethoven's "FÃ1⁄4r Elise"
	notes:
	.word 76, 75, 76, 75, 76, 71, 74, 72, 69, 45, 52, 57, 60, 64, 69, 71, 40, 56,
	59, 64, 68, 71, 72, 45, 52, 57, 64, 76, 75, 76, 75, 76, 71, 74, 72, 69,
	45, 52, 57, 60, 64, 69, 71, 40, 56, 59, 64, 72, 71, 69, 45, 52, 57,
	
	# Let one eighth note (the shortest duration in the tune) be denoted 1,
	# quarter notes etc are multipliers of this duration
	durations:
	.word 200, 200, 200, 200, 200, 200, 200, 200, 300, 200, 200, 200, 200, 200, 200, 300, 200, 200, 200, 200, 200, 200, 300, 200,
	200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 200, 300, 200, 200, 200, 200, 200, 200, 300, 200, 200, 200, 200, 200,
	200, 700, 300, 300, 400
	
	# Indicator of whether the note should be played synchronously
	# (syscall 33 when 0/false) or return asynchronously (syscall 31 when 1/true)
	async:
	.byte 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0,
	0, 1, 0, 0, 0
	length: .word 53 # The length of the song (number of notes) stored in memory

	.text
		main:
			#Initialize #t0 to 0
			addi $t0, $zero, 0
			
		while:
			beq $t0, 212, exit	
			
			lw $a0, notes($t0) # Load notes[0]
			lw $a1, durations($t0) # Set duration of note
			li $a2, 0 # Set the MIDI patch [0-127] (zero is basic piano)
			li $a3, 64 # Set a moderate volume [0-127]
			li $v0, 33 # Asynchronous play sound system call
			syscall 
			# Play the note
			# Registers $a0, $a1, $a2, $a3, and $v0 are not guaranteed to be preserved
			# across the system call, so we must set their values before each call
			
			addi $t0, $t0, 4 #increment the loop
			
			j while
		
		exit:

			li $v0, 10 # exit
			syscall
