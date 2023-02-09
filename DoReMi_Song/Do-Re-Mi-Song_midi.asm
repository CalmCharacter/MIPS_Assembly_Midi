# CPE-4C
# Computer Architecture and Engineering
# Ranario, Aldin Ronulfo M.
# Pimentel, Andre Gabriel C.
# Tabamo, John Bryan A.
.data

	# The following are MIDI-coded tones for Do-Re-Mi song
	# we use Tenor note or C5 for our Do re mi SONG
	# It's beat is very slow and inspired from Do-Re-Mi - The Sound of Music |Piano Tutorial by Betacustic YT Channel
	
	verse1_notes:
		.word  72, 74, 76, 72, 76, 72, 76, 0, 74, 76, 77, 77, 76, 74, 77, 0, 76, 77, 79, 76, 79, 76, 79, 77,
		79, 81, 81, 79, 77, 81

	verse1_durations:
		.word 1000, 200, 1000, 200, 500, 500, 1000, 100, 1000, 200, 200, 200, 250, 250, 2000, 100, 1000, 200, 1000,
		200, 500, 500, 1000, 1000, 200, 200, 200, 250, 250, 2000
		
	verse2_notes:
		.word 0, 79, 72, 74, 76, 77, 79, 81, 0, 81, 74, 76, 78, 79, 81, 83, 0, 83, 76, 78, 80, 81, 83, 84, 0, 83,
		82, 81, 77, 83, 79, 84, 79, 76, 74
		
	verse2_durations:
		.word 100, 1000, 200, 200, 200, 200, 200, 2000, 100, 1000, 200, 200, 200, 200, 200, 2000, 100, 1000, 200, 200,
		200, 200, 200, 2000, 50, 200, 200, 500, 500, 500, 500, 500, 500, 500, 500
		
	ending_notes:
		.word 0, 79, 72, 74, 76, 77, 79, 81, 0, 81, 74, 76, 78, 79, 81, 83, 0, 83, 76, 78, 80, 81, 83, 84, 0, 83,
		82, 81, 77, 83, 79, 84
		
	ending_durations:
		.word 100, 1000, 200, 200, 200, 200, 200, 2000, 100, 1000, 200, 200, 200, 200, 200, 2000, 100, 1000, 200, 200,
		200, 200, 200, 2000, 50, 200, 200, 500, 500, 500, 500, 2000
		
	
.text

		main:
			#Initializing  our registers (t0-t4) for the iterations or while loop that we will be using.
			addi $t0, $zero, 0
			addi $t1, $zero, 0
			addi $t2, $zero, 0
			addi $t3, $zero, 0
			
		verse1_while:
			beq $t0, 120, exit1  # iteration stops or go to exit1 if register $t0 equals to 120
					     # 120 is chosen because verse 1 have 30 notes and each unit of memory address is 4 bytes
					     # so if current address is 10000, then we expect the address of next element is 10004
						
			lw $a0, verse1_notes($t0) # Load notes with their corresponding pitch per iteration
			lw $a1, verse1_durations($t0) # Set duration of note 
			li $a2, 0 # Set the MIDI patch [0-127] (zero is basic piano)
			li $a3, 64 # Set a moderate volume [0-127]
			li $v0, 33 # Asynchronous play sound system call
			syscall 
			# Play the note
			# Registers $a0, $a1, $a2, $a3, and $v0 are not guaranteed to be preserved
			# across the system call, so we must set their values before each call
			
			addi $t0, $t0, 4 #increment the loop of our offset address by 4 to access next element of memory address.
			
			j verse1_while #if 120 iteration is not finish, then it will jump again to verse1_while and it will loop. 
		
		exit1: 
			jal verse2_while #after finishing verse1_while loop then jump and link (jal) to verse2_while loop label
		
		verse2_while:
			beq $t1, 140, exit2 #35 notes for verse 2 multiply by 4 bytes in memory address equals to 140.
			
			lw $a0, verse2_notes($t1) # Load notes of corresponding pitch per iteration (same syntax for lw)
			lw $a1, verse2_durations($t1) # Set duration of note per iteration (same syntax for lw)
			li $a2, 0 # Set the MIDI patch [0-127] (zero is basic piano)
			li $a3, 64 # Set a moderate volume [0-127]
			li $v0, 33 # Asynchronous play sound system call
			syscall 
			# Play the note
			# Registers $a0, $a1, $a2, $a3, and $v0 are not guaranteed to be preserved
			# across the system call, so we must set their values before each call
			
			addi $t1, $t1, 4 #increment the loop of offset address by 4.
			
			j verse2_while #if iteration is not done, then it will jump and go back to loop again.
			
		exit2:
			jal repeatVerse1_while #after finishing verse2_while loop then jump and link (jal) to repeatVerse1_while label
			
		repeatVerse1_while:
			beq $t2, 120, exit3 #same to verse1 we just repeat it according to the song. only change register $t2 for iteration.
			
			lw $a0, verse1_notes($t2) # Load notes of corresponding pitch per iteration (same syntax for lw)
			lw $a1, verse1_durations($t2) # Set duration of note per iteration (same syntax for lw)
			li $a2, 0 # Set the MIDI patch [0-127] (zero is basic piano)
			li $a3, 64 # Set a moderate volume [0-127]
			li $v0, 33 # Asynchronous play sound system call
			syscall 
			# Play the note
			# Registers $a0, $a1, $a2, $a3, and $v0 are not guaranteed to be preserved
			# across the system call, so we must set their values before each call
			
			addi $t2, $t2, 4 #increment the loop offset address by 4 (bytes)
			
			j repeatVerse1_while #if loop is not yet done, it will go back until its finish.
		
		exit3:
			jal endingVerse2_while #after finishing repeatVerse1_while loop then, jump and link (jal) to endingVerse2_while label
			
		endingVerse2_while:
			beq $t3, 128, exit4 #the ending has 32 notes multiply by 4 (bytes) equals to 128 iterations.
			
			lw $a0, ending_notes($t3) # Load notes of corresponding pitch per iteration (same syntax for lw)
			lw $a1, ending_durations($t3) # Set duration of note per iteration (same syntax for lw)
			li $a2, 0 # Set the MIDI patch [0-127] (zero is basic piano)
			li $a3, 64 # Set a moderate volume [0-127]
			li $v0, 33 # Asynchronous play sound system call
			syscall 
			# Play the note
			# Registers $a0, $a1, $a2, $a3, and $v0 are not guaranteed to be preserved
			# across the system call, so we must set their values before each call
			
			addi $t3, $t3, 4 #increment the loop offset address by 4 (bytes)
			
			j endingVerse2_while #if loop not reach 128 iterations then it will go back and continue looping.
		
		exit4:
			li $v0, 10
			syscall #exit the program
			
