Write a recursive-descent parser with backtracking for this grammar:
(1) S → aSbS (2) S → bSaS (3) S → ε
Write your parser in Python. You must have a function backtrack that takes a string and returns a tuple (True,Seq) when the string is in the language (Seq is the sequence your parser applies), or it returns a tuple (False,[]) when the string is not in the language. For example, backtrack(’abbb’) yields (False,[]) and backtrack(’abab’) yields (True,[1,2,3,3,3]).
