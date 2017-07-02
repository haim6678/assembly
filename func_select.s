


	.section 	.rodata
	.align 8
charString: 	    .string "%c"
towCharString: 	    .string " %c %c"  
numberString:  		.string "%d"
mission52String: 	.string "length: %d, string: %s\n"
mission50String:	.string "first pstring length: %d, second pstring length: %d\n"
mission51String:	.string "old char: %c, new char: %c, first string: %s, second string: %s\n"
mission54String:    .string "compare result: %d\n"
wrongInput:       	.string "invalid option!\n"



.switchArray:
				.quad .mission50 
				.quad .mission51 
				.quad .mission52 
				.quad .mission53
				.quad .mission54 
				.quad .default
				.quad .wrong

		.text
.globl fun_funcs           
	.type fun_funcs, @function
fun_funcs:

	leaq	-50(%rdi),%r10		#check what number we get 			
	cmpq 	$4,%r10      		#check if it's good
	ja 	    .wrong			
	jmp 	*.switchArray(,%r10,8)#activate the mission 

.mission50:

	movq 	%rsi, %rdi 	    #the string address
	call 	pstrlen	        #calling pstrlen

	movq 	%rax,%r11  	    #save the first size       
	movq    %rdx,%rdi       #calling second string
	call    pstrlen

	
	movq 	$mission50String, %rdi #the first argumant
	movq 	%r11, %rsi 		    # the second argumant 
	movq 	%rax, %rdx          #the 3rd argumant      
	movq 	$0, %rax	        #initialize rax 
	call 	printf			   

	jmp 	.default           	    #break 

.mission51:

	pushq   %r13                   	 
    pushq   %r14                        
    movq    %rsi,%r14			  # the string address 
    movq    %rdx,%r13			  #the 2 string address 
								
	subq 	$1, %rsp 	         #make place in stack
	movq 	%rsp,%rsi 		 	 #the first char 
	subq 	$1, %rsp 	         #make place in stack
	movq    %rsp, %rdx						 	
	movq 	$towCharString,%rdi   #format        
	movq    $0,%rax
	call	scanf 

	movq    %r14,%rdi        	#string address
	xorq    %rdx,%rdx			
	movb    (%rsp),%dl      	#the new char
	movzbq  1(%rsp), %rsi    	#the old char    																				
    call 	replaceChar      	#call for the first string

    movq 	%r13, %rdi     		#string address
    movzbq  1(%rsp), %rsi  		#old char
    xorq    %rdx,%rdx
	movq    (%rsp), %rdx   		#new char	
	call 	replaceChar    		# for the second string
    

    movq  	$mission51String,%rdi 	#print  string
    movzbq  1(%rsp), %rsi       	#old char
	xorq    %rdx,%rdx
	movq    (%rsp), %rdx   		    #new char	
	leaq    1(%r14),%rcx       		#first string
	leaq    1(%r13), %r8       		#second string
	movq    $0,%rax
	call    printf

	addq    $2,%rsp				#delete chars
	popq    %r14				
	popq    %r13
    jmp 	.default      		#break from this 





.mission52:
 	pushq   %r13                   	#save the rbx
    pushq   %rbx                    	
    movq    %rsi,%rbx			
    movq    %rdx,%r13			
        
	subq 	$4,%rsp                #make place in stack
	movq 	$numberString,%rdi 	   #first arguments
	leaq 	(%rsp),%rsi 		   #first number address  
	movq 	$0,%rax
	call 	scanf 			     	#get the first number

	
	subq 	$4,%rsp                 #make place in stack
	movq 	$numberString,%rdi     #first arguments
	leaq    (%rsp),%rsi 		     #the second number address
	movq 	$0,%rax
	call 	scanf                       
	
	movl   4(%rsp),%ecx 		    #getting the first number 
    movl   (%rsp),%edi          	#getting the second number


   
	movq    %rbx,%rdi       	#the first string
	movq    %r13,%rsi       	#the second string
	movl    4(%rsp),%edx    	#the first index - i
	movl    (%rsp),%ecx     	#the second index - j
	call 	pstrijcpy

	
	movq    %rbx,%rdi      		#the first string
	xorq 	%rax, %rax       		#set rax to 0
	call 	pstrlen        		#get the string size

	movq 	$mission52String,%rdi 		#the print format
    movq    %rax,%rsi                      #the 3rd argument 
    leaq    1(%rbx),%rdx       		      #the first string
	movq 	$0, %rax                      #set rax to 0
	call    printf

	movq    %r13,%rdi   		     #the second string
	xorq 	%rax, %rax       		#set rax to 0
	call 	pstrlen     		     #get the string size										

	movq 	$mission52String,%rdi #the print format   			
	leaq    1(%r13), %rdx                 #the second argument - the 2nd string address
    movq    %rax,%rsi                         #the 3rd argument - the 2nd string size
	movq 	$0, %rax                      #print it  
	call    printf

	addq    $8,%rsp
	popq    %rbx  		     #restore rbx
	popq    %r13 		     #restore r13
	jmp 	.default         #break 


.mission53:

	pushq   %r13            	#save the rbx
    pushq   %rbx            	#save the r12
    movq    %rsi,%rbx		
    movq    %rdx,%r13		
  
	movq 	%rbx, %rdi  		#first string
	call 	swapCase    		#swap all

	movq 	%r13, %rdi  		#second string
	call 	swapCase    		#swap all

	movq 	%rsi,%rdi 		
	xor 	%rax,%rax   	#set rax 
	call 	pstrlen    		

	movq 	$mission52String, %rdi  		#pass the print format 				
	movq    %rax, %rsi                      #pass the first string length
	movq    %rbx,%r10
	addq    $1,%r10
	movq    %r10,%rdx                    #pass the first string
	xor 	%rax,%rax   					#set rax 
	call    printf                          #print it

	movq 	%r13,%rdi #pass the 2nd string
	movq 	$0, %rax  #set rax to 0
	call 	pstrlen   #get it's length

	movq 	$mission52String,%rdi  #pass the print format 			
	movq    %rax, %rsi                     #pass the 2n
	movq    %r13,%r8
	addq	$1,%r8
	movq    %r8,%rdx                   #pass the 2nd string
	xor 	%rax,%rax   			   #set rax 
	call    printf                     #print it


	jmp 	.default                   #break 

.mission54:


	pushq   %r13                  		
    pushq   %rbx                    		
    movq    %rsi,%rbx				# first string 
    movq    %rdx,%r13				#second string 

	subq 	$4,%rsp          		#make place 
	movq 	$numberString,%rdi 		# scan formatin stacj
	movq 	%rsp,%rsi 		     	# first num address   						
	xorq 	%rax,%rax
	call 	scanf                        	


	subq 	$4,%rsp          		#make place 
	movq 	$numberString,%rdi 		#scan format
	movq    %rsp,%rsi		     	#second num address	  						
	xorq 	%rax,%rax
	call 	scanf                          


    
	movq 	%rbx, %rdi     			# first string
	movq 	%r13, %rsi     			# second string
	movl 	4(%rsp),%edx   			# first index
	movl 	(%rsp),%ecx    			# second index
	call    pstrijcmp       		#compare them

	movq    $mission54String, %rdi 	
	movq    %rax, %rsi              #the compare result
	xorq 	%rax,%rax
	call    printf                  #print the  result

	addq    $8,%rsp
	popq    %rbx  					#restore rbx
	popq    %r13					#restore r12
	jmp     .default      			#break from this case


.default:
			xor  %rax,%rax
			ret	
.wrong:

	movq $wrongInput, %rdi		
	xor  %rax, %rax
	call printf

	xor  %rax,%rax
	ret	
