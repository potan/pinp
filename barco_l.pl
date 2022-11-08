
:-[loader].

solve(X) :-
   X=[paso(_), paso(_), paso(_), paso(_), paso(_), paso(_), paso(_), esta(repollo, derecha), esta(lobo, derecha), esta(carba, derecha)],
   runFile("barco.pl", X, _).
