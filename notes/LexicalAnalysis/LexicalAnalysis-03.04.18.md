# Lexical Analysis
The purpose of this analysis is to recognize all the tokens on the program, and classify them.  
Here we don't have a reference to what was the provious read word(s).  
It is used regex and automatons to maje this analysis.  

There are some tools to create such analizers:
  - the Flex: RegEx -> Lexival Analizer (written in C)  

                      |------------------------------------------|
                      |  |----------|  <- next()  |-----------|  |
  --> code.gont ----> |  | lex. an. |  <====== >  | synt. an. |  | -----> code.target
                      |  |----------|   token ->  |-----------|  |
                      |------------------------------------------|

**NOTE**: the Lexical analizer is bassically a sub-routine of the syntax analizer

Example: consider the following program
  - automaton for identifie a identifier or a floating point number  

```
-> [a] -- C --> {b} << C/D
    \-- D --> [c] -- "." --> [d] -- D --> {e} << D
```
Automaton 1.: a simple automaton to recognize a identifier or a floating point number

Legend:  
[a] : state a of the automaton  
-- D --> : transition where the D is consumed  
<< : it is a loop  
D : digit  
C : character  

The same automaton could be descibred on a table, where the columns are the **tokens** of the language (i.e. D, ".", C)
|     | D   | .   | L   |
|---- |---  |---  |---  |
| 1.  | 3   |     | 2   |
| 2.  | 2   |     | 2   |
| 3.  | 3   | 4   |     |
| 4.  | 5   |     |     |
| 5.  | 5   |     |     |
Table 1: the same Automaton 1. but in a table format  

Example: consider the following automaton  

Automaton 1.: 
```
-> [a] -- C --> {b} << C/D
    \-- D --> [c] -- "." --> [d] -- D --> {e} << D
     \
      \                           C|D|"("          "*"
       \                            v               v
        \                           v               v
         \-- "(" --> [f] -- "*" --> [g] -- "*" --> [h] -- ")" --> {i} 
                                     ^               /
                                      \             /
                                       \ -- "(" -- /
```
Automaton 2.: a automaton to recognize either a identifier, or a floating point number, or a comment section ```(* ----- *)```

Now we a pseudo-code to implement the previous Automaton 1.  

```
  ident   := nil
  number  :
  char    := get_char()
  while (char == '') { char := get_char() }
  if (is_letter(char)) {
    while ((is_letter(char) || (is_digit(char)) {
      ident := ident ++ char
      char  := get_char()
    }
  } elif (is_digit(char)) {
    while(is_digit(char)) {
      number  := number ++ char
      char    := get_char()
    }
  }
```
Code 1.: implementation of the Automaton 1., to recognize either a identifier or a floating point number

Even that the lexical analizer makes part of the syntax analizer, we study it as a separeted part, because:  
  - it has it own error  
  - it makes it simpler to learn and understand the compilation process  

DEFINE: *token** is the class to where a recognized word belongs  

DEFINE: **lexem**  is the word that have been read  

DEFINE: **patern** is other way to refer to the regular expression used  

## Lexical Erros  
There is just a few of those error, manly beacause they indicate a error on forming a word on the program.  
  - e.g. identifier that begin with a number are invalid in C/Java/...  
  - e.g. snake_case identifier are mandotory in Rust  

Exercise: 
1) Create a regular expression that recognize the number in Pascal.  

```
  I := 1|..|9
  D := 0|I
  N := ID* | ID*.ID* | ID*EID* | ID*E+ID* | ID*E-ID
```
Other solution: 
```
  (1|..|9)(0|..|9)*(.(0|..|9)*(1|..|9))?((+|-)?E(1|..|9)(0|..|9)*)?
```
Examples:  
  65.01+E10 => ok
  6 => ok
  15 => ok
  15E50 => ok
  6.3E500 => ok

2) Create a regular expression to recognize a valid identifier.  
```
  (a|..|z)(a|..|z|0|..|9)*((a|..|z|0|..|9)*_(a|..|z|0|..|9)+)*(a|..|z|0|..|9)*
```
Examples:  
  aaa0099555ddd_1a5a5a4 => ok
  a => ok
  aaaaaaa000000a2a2a2a => ok
  a_12221aas1 => ok


