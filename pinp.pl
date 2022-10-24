
mkfree([], []).
mkfree([V|T], [(V,_)|TF]) :- mkfree(T, TF).

subst(F, V, O) :- atom(V) ->
        ( member((V, R), F) -> O=R ; O=V ) ;
        var(V) -> O=V ;
	( V =.. [P | A], maplist(subst(F), A, N), O =.. [P | N] ) .

setfree((N, V), O) :-
  mkfree(N, F),
  maplist(subst(F), V, O).

atoms(T, A) :-
  atom(T) -> A=[T] ;
  var(T) -> A=[] ;
  T =.. [_ | L], maplist(atoms, L, LL), append(LL, A).

nextatom(D, A, N) :-
  name(A, M),
  append(M, [97], NM),
  name(NP, NM),
  (member(NP, D) -> nextatom(D, NP, N) ;
  N = NP).

fillfree(D, V, (A, L), (AN, LN)) :-
   (var(V) -> (nextatom(D, A, AN), V = A, LN = [A | L]) ; 
   atom(V) -> AN=A, LN=L ;
   V =.. [_ | F],
   foldl(fillfree(D), F, (A, L), (AN, LN))).

fillfree(V, VO, L) :-
  atoms(V, A),
  nextatom(A, w, I),
  findall((V, L1), fillfree(A, V, (I,[]), (_,L1)), [(VO, L)]).

tuple2list(T, [S | L]) :-
   T = (H, R) -> tuple2list(H, L1), tuple2list(R, L2), append(L1, L2, L) ;
                 S = T, L = [].

def2list(T, [P | O]) :-
   T = (P :- D) -> tuple2list(D, O) ;
                   P = T, O = [].

compile(P, I) :-
  (P = (H, T)) -> compile(H, I1), compile(T, I2), append(I1, I2, I) ;
  (P = (C -> T ; E)) -> compile(C, IC), compile(T, IT), compile(E, IE), I = [IC -> IT ; IE];
  I = [P].

compileDef(P, I) :-
  (P = (D :- C)) -> compile(C, IC), I = [D | IC];
  I = [P].

deleteall(_, [], []).
deleteall(P, [E | L], O) :-
  (P = E -> fail ;
            deleteall(P, L, O1), O = [E | O1]) ->
              true ;
              deleteall(P, L, O).

doio(DB, write(X), DB) :- write(X).
doio(DB, writeln(X), DB) :- writeln(X).
doio(DB, nl, DB) :- nl.
doio(DB, (P -> T ; F), NDB) :-
   check(P, DB, TDB) -> check(T, TDB, NDB) ; check(F, DB, NDB).
doio(DB, asserta(P), [(V,DO)|DB]) :- def2list(P, D), fillfree(D, DO, V).
doio(DB, asserta_internal(P, V), [(V,P)|DB]).
doio(DB, assert(P), NDB) :- def2list(P, D), fillfree(D, DO, V), append(DB, [(V, DO)], NDB).
doio(DB, assertz(P), NDB) :- def2list(P, D), fillfree(D, DO, V), append(DB, [(V, DO)], NDB).
doio(DB, retract(P), DBO) :- def2list(P, D), deleteall((_,D), DB, DBO).
  
check([], DB, DB).
check([P|R], DB, DBO) :-
  (doio(DB, P, DBN) ->
     true ;
     (member(D, DB),
      setfree(D, [P | B]),
      check(B, DB, DBN))),
  check(R, DBN, DBO).

