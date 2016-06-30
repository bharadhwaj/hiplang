# HIPLANG

 This is just our try to create our own compiler.  
 
## USER MANUAL

In order to run the file.  

1. Navigate to the folder.  
2. Compile the _yacc_ file as  
	```
	yacc -d hiplang-yacc.y  
	```
3. Compile the _lex_ file as  
	```
	lex hiplang-lex.l  
	```
4. After compiling lex and yacc, we now obtain two C files. Now compile those files as:  
	```
	gcc lex.yy.c y.tab.c -ll  
	```
5. Finally, in order to try sample run with you own inputs, try giving,  
```
	./a.out
	```  
   and try with your inputs.  
   In order to run the sample file attached, try giving,  
	```
	./a.out < sampleinput.hip
	```
