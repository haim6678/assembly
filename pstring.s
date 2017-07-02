
	.section  .rodata
	.align 8

wrongFormat: .string "invalid input!\n"



	.text
.globl pstrlen 		           		
	.type pstrlen, @function
pstrlen:
		
		
		movq	$0, %rax		#set to  0
		movb	(%rdi), %al 	# return size 

		ret 				    #finish

.globl replaceChar                  		
	.type replaceChar, @function
replaceChar:
			

		call	pstrlen		#string length
		xorq 	%r8,%r8		#a counter
		incq    %rdi        #the string address		
													
.runString: 
			
		cmpq	%r8, %rax	#cmp counter and length
		jbe     .doneReplace#equals
		
		movb    (%rdi),%r9b 
		cmpb 	%sil,%r9b       #cmp  old and current char 	
		je 	.replace			#equals

		addq    $1,%rdi 		#move to  next 		
		addq    $1,%r8			#inc counter
		jmp	.runString			#move on

		
.replace:  
		movb  %dl,(%rdi) 	    #move the new char in 
		addq    $1,%rdi 		#move to  next 		
		addq    $1,%r8			#inc counter
		jmp   .runString	

.doneReplace:  
		movq 	%rdi,%rax 	#return val_the string pointer
		ret					#return


										
.globl pstrijcpy 				
	.type pstrijcpy, @function
pstrijcpy:
	
	
	call pstrlen   			#check string size

	movq %rax,%r9 			#save  string size

	pushq %rdi
	movq %rsi,%rdi
	call pstrlen   			#the other string size
	popq %rdi

	movq %rax, %r8 			#the other string size

	cmpq %rdx,%r9 			# start  bigger then first size
	jb   .insert2

	cmpq %rcx,%r9 			# finish  bigger then size
	jb   .insert2

	cmpq  $0,%rdx 			#if the start  smaller then 0
	jb   .insert2

	cmpq %rcx,%r8 			# finish bigger then size
	jb   .insert2

	cmpq %rdx,%r8 			
	jb   .insert2
	

	movq %rcx, %r8 			#the end 
	subq %rdx, %r8			#the start minus the end
	addq $1,%r8      			
	movq $0,%r10 			#the counter


.copy:
	cmpq %r10,%r8  			#check if finish
	jbe  .finish 			#if we finish go out 

	movzbq 1(%rdx,%rsi),%r9 	
	leaq   1(%rdx,%rdi),%r11 	
	movb   %r9b,(%r11)      	

	addq 	$1,%r10 			#increment counter
	addq    $1,%rdx    		

	jmp .copy			#move on


.finish :
	movq	$0,%rax			
    ret

.wrong:
	movq $wrongFormat,%rdi #the print
	movq $0,%rax			
	call printf 			#print  massage
	jmp  .finish 			#finish         

.insert2:	
	movq $-2,%rax
	jmp	  .wrong


.globl swapCase     
    .type swapCase, @function
swapCase:

	call pstrlen 				#string size

	movq  $0,%r8 				#counter		
	addq  $1,%rdi 				#increment by 1

.swap:
	cmpq   %rax,%r8    		    #if we done 
	jae    .finishSwaping		#we finish

	xorq   %r10,%r10
	movb   (%rdi),%r10b  		#first char
								       	
	cmpb   $65,(%rdi)    		#if it's not a letter
	jb     .nonLetter 

	cmpq    $122,%r10   		#if it's  not a letter
	ja     .nonLetter							


	cmpq   $97,%r10   			#if it's  a little letter
	jae    .littleLetter

	cmpq   $90,%r10   			#if it's a big letter
	jbe     .bigLetter

.nonLetter:
		
	addq  $1,%rdi 			#go to next 
	addq  $1,%r8 			#increment the counter
	jmp   .swap 		    #go looping

.littleLetter:
	
	subq  $32,%r10    		#convert to big
	movb  %r10b,(%rdi)		#put in string
	addq  $1,%rdi        	#go to next 
	addq  $1,%r8        	#increment the counter
	jmp   .swap  			#go looping

.bigLetter:
	
	addq  $32,%r10    		#convert to little
	movb  %r10b,(%rdi)		#put in string
	addq  $1,%rdi       	#go to next 
	addq  $1,%r8       		#increment the counter
	jmp   .swap 			#go looping

.finishSwaping:
    ret 
    

.globl pstrijcmp 			#the compare function
        .type pstrijcmp, @function
pstrijcmp:
	
	
	call pstrlen   			#check string size

	movq %rax,%r9 			#save  string size

	pushq %rdi
	movq %rsi,%rdi
	call pstrlen   			#the other string size
	popq %rdi

	movq %rax, %r8 			#the other string size

	cmpq %rdx,%r9 			# start  bigger then first size
	jb   .insert2cmp

	cmpq %rcx,%r9 			# finish  bigger then size
	jb   .insert2cmp

	cmpq  $0,%rdx 			#if the start  smaller then 0
	jb   .insert2cmp

	cmpq %rcx,%r8 			# finish bigger then size
	jb   .insert2cmp

	cmpq %rdx,%r8 			
	jb   .insert2cmp


	movq %rcx, %r8 			#move the end 
	subq %rdx, %r8 			#sub the start from end
	addq  $1,%r8       		
	movq  $0,%r10 			#counter
	movq $0,%rax 			#set the return val

.cmp:
	cmpq %r10,%r8 			#check if we done copy
	jbe  .finishCmp 		#if we finished copy

	movzbq 1(%rdx,%rdi),%r11 	#move the char from the first strint to r11
	movzbq 1(%rdx,%rsi),%r9 	#move the char from the second strint to r8

	cmpq %r9,%r11 			#compare them
	je   .equal  			#they are equals
	ja   .first 			#the first is bigger
	jb   .second 			#the second is bigger

.equal:
	addq 	$1,%r10 		#increment  counter
	addq    $1,%rdx    		#inqrement where to copy to 
	jmp     .cmp	

.first:
	movq $1,%rax  			#the first is bigger
	jmp  .finishCmp 			

.second:
	movq $-1,%rax 			#the 2nd  is bigger
	jmp  .finishCmp 		

.wrongCmp:
	
	pushq %rax
    movq $wrongFormat,%rdi 	#print format
	movq $0,%rax			
	call printf 			#print  massage

	popq %rax               #restore  register
	jmp  .finishCmp			#finish 


.insert2cmp:           
	movq $-2,%rax
	jmp	  .wrongCmp
   	
.finishCmp:
    ret    	