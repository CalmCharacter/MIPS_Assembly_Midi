# CPE-4C
# Computer Architecture and Engineering
# Ranario, Aldin Ronulfo M.
# Pimentel, Andre Gabriel C.
# Tabamo, John Bryan A.
.data

	# The following are MIDI-coded tones for Happy Birthday To You (Portion)
	# Middle C or C4 note on piano
	notes:
		.word  60, 60, 62, 60, 65, 64, 0, 60, 60, 62, 60, 67, 65, 0, 60, 60, 72, 69, 65, 64, 62, 0, 70, 70, 69,
		65, 67, 65

	durations:
		.word 300, 300, 800, 800, 700, 800, 200, 300, 300, 700, 600, 600, 800, 200, 300, 300, 650, 700, 750, 800,
		500, 200, 300, 300, 650, 650, 650, 800

.text

		main:
			#Initialize #t0 to 0
			addi $t0, $zero, 0
			
		while:
			beq $t0, 112, exit #this is the code where the iteration begin. conditions is if $t0 equals to 112 go then go to exit.
					   #112 is chosen because we have 28 notes. and in memory each unit of base address is 4 bytes.
					   #so if current address is 10000 then, the address of next element is 10004
					   
			lw $a0, notes($t0) # Load notes with their corresponding pitch per iteration 
			lw $a1, durations($t0) # Set duration of note per iteration 
			li $a2, 0 # Set the MIDI patch [0-127] (zero is basic piano)
			li $a3, 64 # Set a moderate volume [0-127]
			li $v0, 33 # Asynchronous play sound system call
			syscall 
			# Play the note
			# Registers $a0, $a1, $a2, $a3, and $v0 are not guaranteed to be preserved
			# across the system call, so we must set their values before each call
			
			addi $t0, $t0, 4 #increment the loop of our offset address by 4 to access the next offset address in the memory.
			
			j while #if iteration is not equal to 112, then it will jump again to while label until its done.
		
		exit:
			li $v0, 10
			syscall #exit the program
