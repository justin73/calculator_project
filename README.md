# calculator_project


this project started on 9/20 evening, on average, worked 2.5 hours every night, so in total it took abour 7.5 hours.

Due to the time limits, there are a couple of things which hasn't been implemented yet, i will keep working on them 
and will let you know when i am done with them
 (1) comma display : ran into some problems with 7+ digits display, so the code is temporarily commented out.
 (2) keyboard input is not implemented yet: for this, the idea is to replace the current display bar(p tag) with an input element,
     and only allows keyboard input with numebrs and operators.
 (3) data validation is not done completely: parenthese validation not complete 

For now, the calculator can do:
  1. single operator calculation, e.g. +,-,*,/ for both integer and decimal numbers
     2345+1234, 23.45+45.345
  2. mixed operators calculation, e.g. + and -, + and /, + and * and / and -,etc for both integer and decimal numbers
     2+3/4+5, 2-4*6+2
  3. with parentheses calculation, e.g. 2*(3+4*5)+6, for both integer and decimal numbers
    
  
  
Exisiting bugs:
  1. mixed operator calculation: there is a bug with two secondary operators(x,/) using together, such as 3+4x5/6
  2. parenthese calculation:  exisiting bug which is when the value inside parenthese is negative, then it fails
  3. since validation is not done yet, so for parenthese calculation, there are some non-valid format still allowed

Needs to imporve:
 UI, interaction as well as aesthetics... 
 
 
Thoughts:
   Life is not complete without libraries.... LOL 
