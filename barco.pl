
:- dynamic(barco/1).
:- dynamic(esta/2).

barco(izquierda).
esta(carba, izquierda).
esta(lobo, izquierda).
esta(repollo, izquierda).

costados(izquierda, derecha).
costados(derecha, izquierda).
comer(lobo, repollo).
comer(repollo, lobo).

movimiento(X) :-
  barco(L),
  esta(X, L),
  costados(L, N),
  retract(esta(X, L)),
  asserta(esta(X, N)),
  retract(barco(L)),
  asserta(barco(N)).

paso(carba) :-
  movimiento(carba).

paso(X) :-
  comer(X, Y),
  esta(carba, L),
  costados(L, O),
  esta(Y, O),
  movimiento(X).

paso(none) :-
  esta(carba, L),
  costados(L, O),
  esta(lobo, O),
  esta(repollo, O),
  barco(X),
  costados(X, N),
  retract(barco(X)),
  asserta(barco(N)).
