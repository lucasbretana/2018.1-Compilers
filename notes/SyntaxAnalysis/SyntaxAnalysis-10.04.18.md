# Syntax Analysis
- That is the second part of the compilation process. 
- This part will receive the **tokens** from the first part and verify its sequency  
- Will then produce a intermediate interpretation of the font code, called **parse tree** (pt-BR: arvore sintatica)  

                     |------------------------------------------------------------------------|
                     |                                                                        |
                     | |------------------------------------------|                           |
                     | |  |----------|  <- next()  |-----------|  |                           |
  --> code.gont ---->| |  | lex. an. |  <====== >  | synt. an. |  |                           |  -----> code.target
                     | |  |----------|   token ->  |-----------|  |                           |
                     | |   ^                                  ^   | --> parse --> ... -->     |
                     | |    \                                /    |      tree                 |
                     | |     v                              v     |                           |
                     | |    |--------------------------------|    |                           |
                     | |    |         symbol table           |    |                           |
                     | |    |--------------------------------|    |                           |
                     | |                                          |                           |
                     | |------------------------------------------|                           |
                     |------------------------------------------------------------------------|


There are two ways to implement:
  - manually (normally using the Top-Down strategy)  
  - using tool (iddeally using the Bottom-Up strategy)  

The Top-Down strategy may require a few modification on the grammar of the language, changing:  
  - remove left recursion  
  - factorization  

Those tools to generate the analizer normally receive a grammar (BNF) and returns a parser written on some language.
  - Javacc: BNF -> lexical analizer written in Java  
    + uses Top-Down strategy  
    + does much more thatn just that  
  - Yacc: BNF -> lexical analizer written in C  
    + Bison is the free option  

## Analizers
  - can result two different types of parse tree:  
    + Top-Down: tree from root to leaves  
    + Bottom-Up: tree from leaves to root  

  - the Top-Down follows the application of the grammar rules  
    E    :: E -> D
    /\
   E  E
  /\  ...

  - the Bottom-Up generates an automaton and avoid many problems  
    R -> ab             E -> ...R...X...
    ...                 [] -- a --> [] -- b --> {} << R
    X -> aE                           \[] -- c --> {} << X

  - most errors occur when the compiler cannot generate a parse tree  

  - there are mechanisms to deal with those errors:  
    + with corrections  
    + without corrections  
  
  - **with corrections**, when an error é found the compiler guessesa correction so it can continous and find others errors  
    + the problem with this technic is that one mistaken correction could result on more erros  

  - **without corrections**, when an error is found the current analysis is discarted and restarts on another point  
    + it is very difficult to know where to restart, the grammar needs to be changed on the compiler execution time  

###### Continuing on 17.04.18

- Top-Down
  + (commonly) manually implemented  
  + simpler  
  + more restrict set of grammars  

- Bottom-Up
  + (commonly) created using tools  
  + complex  
  + less restrict set of grammars  
  + uses an automaton  

## Top-Down  
- build a parse tree starting from the very **fisrt** rule on the grammar, expanding until finding the terminals  

### Recursive descengind parser  
- easy way to implement a Top-Down analizer  
- all non-terminals from the grammar became boolean functions that return TRUE if they recognize the corresponding entry  
- terminals and non-terminals sequency are recognized using AND and OR  

Example:  
```
  A -> BC | d
  B -> b
  c -> c
```
The code generated could be:
```
  bool A() 
    return B() && C() || token('d')
  bool B()
    return token('b')
  bool C()
    return token('c')
```
**NOTE**: Those parser need to go back on the alternatives  

- as we saw, the Top-Down strategy accpets a more restrict set on languages
  + some time it requires modification on the original grammar  

#### Common problems with the recursive descengind parser
  - needs to go back on alternatives, witch causes unnecessary computation and slow down the compiler  
Example: entry: z
```
  START -> A|..|Z
  A     -> a
  ...
  Z     -> z
```
    + the parser will run throw all the 26 possible entry before finding the right rule  
    + note that this **doesn't procude a wrong parser**, it only may be slow  
    + a possible solution is to use the predictive parser  
      * this kinda of parser knows what each alternative recognize, to avoid expand unecessary rules  

  - another problem is that for some construction of LLC grammar it will produce an incorrect parser  
Example:
```
  EXP       -> ID | ELEM_IND
  ELEM_IND  -> ID[EXP]
```
The code:
```
  bool EXP()
    return token(ID) || ELEM_IND()
  bool ELEM_IND()
    return token(ID) && token('[' && EXP() && token(']')
```
    + the problem is the ambiguit on recognize ELEM\_IND 

Example:
```
  a[b]
```
    + Would be recognized in the first rule, leaving the "[B" behind, rejecting the valid construction  
    + the solution is:
      * apply a substituion (change the non-terminal by its alternatives) in the call of ELEM\_IND, leaving: 
```
  EXP -> ID | ID[EXP]
```
      * now, the grammar needs to be factored  

| A -> bD | bC  |
|-------------- |
| A -> bA'      |
| A' -> D | C   |

Table 2.: grammar factorization  
```
  EXP   -> ID EXP' 
  EXP'  -> [EXP] | <empty>  
```

Example:  
```
  S -> Aab  
  A -> a | <empty>  
```

Substitution:  
  S -> **a**ab | **a**b  

Factorization:  
```
  S   -> aS'  
  S'  -> ab | b  
```

  - another thing that causes a incorret parser is:  
    + left recursion  
Example: 
```
  EXP -> EXP + TERM | TERM  
```
Code:  
```
  bool EXP()  
    return EXP() && token('+') && TERM() || TERM()  

    + solve by refactoring the grammar  

| A -> Ab | c         |
|-------------------- |
| A -> cA'            |
| A' -> bA' | <empty> |
Table 3.: grammar fecatorization  

```
  EXP   -> TERM EXP'
  EXP'  -> + TERM EXP ' | <empty>

```

Examples: 
1)
```
  S     -> TYPE LIST; | S TYPE  LIST;
  TYPE  -> bool | int
  LIST  -> ID | LIST, ID
```

