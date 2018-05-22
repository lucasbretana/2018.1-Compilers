# Intro
The compiler is a software that read a program written on a **font** language and translates it ti a **equivalent** program written in another **taget** langue.  

                 |-------|
code.font   ---->| comp. | ----> code.target
                 |-------|


The compiler can be divided into two main parts: 
  - Front End, also know as analysis  
  - Back End, also know as sintesis part  

                 Compiler:
                 |--------------------------------------|
                 |    |-----------|     |----------|    |
code.font   ---->| -> | Front End | --> | Back End | -> |----> code.target
                 |    |-----------|     |----------|    |
                 |--------------------------------------|

Consider the following examples:  
Ex.: 
```
  x = tmp + y * 10
```
Sending it to the *lexical analysis* would produce somewhat of the following **tokens**:  
<"x", ID>
<"tmp", ID>
<ATTRIB>
<SUM>
<"y", ID>
....

The *syntax analysis*, would produce the following parse tree, but about this analysis know that:  
  - it has all the rules of the language grammar, 
    + e.g.: ATTRIB -> ID = E
    +     : E -> E + E | E * E | n | ID

   ATTRIB:
  /      \
ID   :=   E
 |       /|\ 
"x"     / + \
       E     E
      |    / | \
      |   |  |  \
      ID  E  *   E 
      |   |      | 
    "tmp" ID     n
          |      |
         "y"    10
Tree 1: a parser tree (pt-BR: arvore sintática)  


  - this analysis will consumes all tokens providen by the lexical analiser, throw the entire file, where:  
    + if the file is fully consumed, then the program respect all the syntax rules  
    + otherwise it doesn't respect one or more rules, and the compilation aborts  

The **semantics analysis** will receive the parser tree, and go through it (possibly making some modification and adding stuff).  
The result will be the ~possibly~ modified tree with some important information about semantics, for instance the expressions and operation types.

So the Tree 1. would have its nodes typed as int for instance.

    ATTRIB:
   /   |   \
  /    |    \
ID    :=     E            <- both side of the attribution are int, so its a valid attribution
 |          /|\ 
"x"        / + \          <- both side of the + are int, so this expression also is a valid int 
(int)     E      E        <- both side of the * are int, so this expression also is a valid int
          |    / | \
          |   |  |  \
          ID  E  *   E    <- if "y" and 10 are int, so are those expression
          |   |      | 
       "tmp"  ID     n
       (int)  |      |
             "y"     10
            (int)   (int)

Tree 2: a parser tree with some types annoted all the way

The **Intermediate code generation** create a equivalent program ona middle term language, very common for many compilers. It is, tically, a 3 register operation kinda of languge, for instance LLVM language.  

The **optimization** step is where the code is improved, based on some architecture aspects, for better recurses use (like CPU and memory)
**NOTE**: remember the cache 

The **target code generation** is the step where the program is created on the **target** language. If the compiler is written using the intermediate code and using some common intermediate language (such as LLVM) then only this part needs to be re-written when creating the compiler for others plataforms.

###### Continuing on 28.04.18
Some defitions: 
  - **compiler**: is a program that reads another program written on a **font** language and translates to a equivalent program written on another **target** language.

  - the **symbol table** have many informations about the identifiers on the code  
    + it is used and modified many times during the compilation  

NOTE: **pretty printer** is a program that receives a parser tree and returns the codes of that tree  
NOTE: the precedence order for operations of a languge could be embedded on the grammar of the language  

###### Continuing on 03.04.18
Languages can be strong or weakly typed,  
  + Java, Haskell -> strongly  
  + C -> middle term  
  + JS -> weakly, or without types  

NOTE: there is a **BIG** problem on manking good use of the registe (I'm almost sure it is a NPC problem)
