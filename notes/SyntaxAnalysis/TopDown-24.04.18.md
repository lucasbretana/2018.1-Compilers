# Top Down analysis
## Recursive descendent parser
  - does not deal with left recursion  
  - does not deal with alternatives that start with the same symbol  

  - go back through rules  
    + makes the analysis **slower**  

Example: entry: z
```
  A -> B | B | .. | Z
  B -> b
  ....
  Z -> z
```

## Predictive recursive parser  
  - this parser only calls alternatives that generates some terminal that is on the entry  

  - for this we use an algorithm that collects the terminals for each alternative  

  - normally implemented using tools  

  - the **ideia** is: calculate wich ones are the _first temrminals_ that are genereted for each grammar rule  

  - this way, looking at the entry, we choose the directly the ruçe that consumes the symbol present on the beggin of the entry, instead of try alternatives until the symbol is consumed  

Example:
```
  A -> B | C | .. | Z
```
Becames:
```
  bool A() 
    if (next_token() == 'b')
     return B()
    if (next_token() == 'c')
     return C()
    ...
    if (next_token() == 'z')
      return Z()
```

### First set
The following algorith calculates the **first** set:  
  - Initialization: 
    1. if **a** is a terminal, then **FIRSRT**(**a**) = {**a**}  
    2. if X -> <empty>, then add <empty> to the **FIRST**(X)  
  - Inference:  
    3. for each alternative like: N -> A  
      + **FIRST**(N) must contains **FIRST**(A)  
    4. for each alternative **A**, on the format **BC**  
      + **FIRST**(**A**) must conatins **FIRST**(**B**), expect <empty> if present  
Example:
```
  CMD     -> ATRIB | ITER | IF 
  ATTRIB  -> ID := E
  ITER    -> do CMD while E |
              | while E do CMD
  IF      -> if E then CMD else CMD
  E       -> ...
```
**NOTE**: it is easier to calculate the FISRT set starting from the last rule on the grammar  

  FIRST(IF)     = {if} 
  FIRST(ITER)   = {do, while}
  FIRST(ATTRIB) = {ID}
  FIRST(CMD)    = {ID, do, while, if}

#### The problem with the FIRST set
The FIRST set that we learn how to calculate does not solve all the problems. Consider the following example:  
```
  A -> B | CD | E
  B -> b
  C -> c | <empty>
  D -> d
  E -> e
```

FIRST(E) = {e}   
FIRST(D) = {d}  
FIRST(C) = {c, <empty>}   
FIRST(B) = {b}  
FIRST(A) = {b, c, e}  

**NOTE**: if the <empty> is generated so, it indicates that is necessary to know the **followin** symbol  

**NOTE**: **FOLLOW** the set of the tokens that follow the terminals  

### Follow set
- is the set of the first symbols that appers **after** the call of a rule.  

- it is necessary qhen the rule have a <empty> on its **first** set  

The followinf rules are used to calculate a rules' **follow** set:  
  1. if **S** is the initial rule of the grammar and $ represent the EOF, then $ is in the **FOLLOW**(**S**)  
  2. for all rules like: A -> BCD  
    + **FIRST**(**D**) is contained inside the **FOLLOW**(**C**)  
  3. for all rules like: A -> BC, or A -> BCD, where D generates the <empty>  
    + the **FOLLOW**(**A**) is in the **FOLLOW**(**C**)  

#### Exercises:
1) Exercise: calculate the **FIRST** and **FOLLOW** set, for:  
a)  
```
  DS  -> D DS'  
  DS' -> ; DS | <empty>  
  D   -> a
```
FIRST(D)    = {a}
FIRST(DS')  = {;, <empty>}
FIRST(DS)   = {a}

FOLLOW(D)   = {$, ;}
FOLLOW(DS') = {$}
FOLLOW(DS)  = {$} 


b)
```
  D     -> IF | a  
  IF    -> if (EXP) D ELSE  
  ELSE  -> else D | <empty>  
  EXP   -> 0 | 1  
```
FIRST(D)      = {if, a}
FIRST(IF)     = {if}
FIRST(ELSE)   = {else, <empty>
FIRST(EXP)    = {0, 1}

FOLLOW(D)     = {$, else}
FOLLOW(IF)    = {$, else}
FOLLOW(ELSE)  = {$, else}
FOLLOW(EXP)   = {)} 

**NOTE**: first and follow set should be calculated **after** the refactorization of the grammar, i.e., the grammar should be ready to be implemented on a recursive descendent parser.

#### Exercises:

**COPY**


###### Continuing on 08.05.18

All parsers that we look so far are Top-Down

## Tabular predictive parser  
  - uses a explicit stack instead of recursion  

  - using the first and follow sets the parser creates a table that indicates, according with the entry, witch rules should be used  

### Creating a predictive table
The following steps should be taken to create a predictive table  
  1. eliminate all grammar conflicts (factorize, eliminate left recursion, ...)  
  2. calculate the **follow** and **first** sets  
  3. create a table where:  
    + the columns name are the terminals  
    + the rows names are the non-terminals  
  4. fill the table using the **first**  
    + for each non-terminal T inside the **FIRST**(**S**) put the rule from **S** that consumes **T**  
  5. if the FIRST(**S**) containes <empty> so for each terminal **T** inside **FOLLOW**(**S**), add the rule
    S -> <empty>

Exemple: 
```
  DS  -> D DS'
  DS' -> ; DS | <empty>
  D   -> a
```


