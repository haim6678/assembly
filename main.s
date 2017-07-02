	.section	.rodata
	.align 	8    					
LengthFormat:	.string "%d"
getString:	    .string "%s"
charFormat: 	.string "%c"

	.text
.globl main 				
	.type main, @function
main:

	pushq %rbp      #save the previous start frame 
	movq %rsp, %rbp #initialize the rbp to point to the current frame
	pushq %r12      #save the rbx register

#first string
	subq	 $4, %rsp		   		 # make place in the stack by 4
	movq 	$LengthFormat, %rdi		#pass the first agrument 
	movq 	%rsp, %rsi 		        #pass the second argumentd 
	movq 	$0, %rax		     	#set rax to 0
	call	scanf 			        #call scanf func

	movl    (%rsp),%r12d			#save the size
	addq    $4,%rsp                 #reduce the stack size

	addq    $1,%r12                 #plus 1 for /0 
	subq    %r12,%rsp 			    #make place for string
																		#to check if i need to put /9
	movq 	$getString, %rdi		#pass the first agrument 
	movq 	%rsp, %rsi 		        #pass the second argumentd 
	movq 	$0, %rax		     	#set rax to 0
	call	scanf 			        #call scanf func


	subq 	$1,%rsp	
	subq    $1,%r12		
	movb 	%r12b, (%rsp)			   #the stirng size in the stack  					
#second string
	subq	$4, %rsp		        # make place the stack by 4
	movq 	$LengthFormat, %rdi  	#pass the first agrument 
	movq 	%rsp, %rsi 		        #pass the second argumentd 
	movq 	$0, %rax		     	#set rax to 0
	call	scanf 			        #call scanf func

	movl    (%rsp),%r12d			#save the size
	addq    $4,%rsp                 #reduce the stack size

	addq    $1,%r12                 #plus 1 for /0 
	subq    %r12,%rsp 			    #make place for string

	movq 	$getString, %rdi		#pass the first agrument 
	movq 	%rsp, %rsi 		        #pass the second argumentd 
	movq 	$0, %rax		     	#set rax to 0
	call	scanf 			        #call scanf func

	subq 	$1,%rsp	
	subq    $1,%r12			
	movb 	%r12b, (%rsp)			   #the stirng size in the stack  

#func_select
	subq	$4, %rsp				# make place in the stack by 4
	movq 	$LengthFormat, %rdi		#the first agrument
	movq 	%rsp, %rsi 				#the second argument 
	movq 	$0, %rax				#set rax   
	call	scanf 	


	#pass the arguments
	movl	(%rsp),%edi 			#the mission number 

	xorq    %rax,%rax
	leaq    4(%rsp), %rax
	xorq    %r10,%r10
	movb    (%rax),%r10b		
	addq    $2, %r10
	addq    %rax,%r10			
	movq 	%r10, %rsi				#passing the first string address

	leaq    4(%rsp),%rdx			#the second string address	
			
																	             														
	call 	fun_funcs

	popq  %r12 		#restore register
	movq  %rbp,%rsp #restore stack frame
	popq  %rbp
	ret
