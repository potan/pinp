
:- [pinp].

process([], []).
process([P|T], R) :- 
  process(T, R0),
  (P = (:-_) -> R = R0 ;
               (def2list(P, D), fillfree(D, DO, V), R = [(V, DO) | R0])).

loadFile(F, C) :-
  read_file_to_terms(F, L, []),
  process(L, C). 
