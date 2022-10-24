
:- [pinp].

solve(X, R) :-
   X = [paso(_), paso(_), paso(_), paso(_), paso(_), paso(_), paso(_), esta(repollo, derecha), esta(lobo, derecha), esta(carba, derecha)],
   PROG = [([], [barco(izquierda)]),
           ([], [esta(carba, izquierda)]), ([], [esta(lobo, izquierda)]), ([], [esta(repollo, izquierda)]),

           ([], [costados(izquierda, derecha)]), ([], [costados(derecha, izquierda)]),

           ([x, l], [seguro(x), esta(carba, l), esta(x, l), barco(l)]),
           ([x, l, o], [seguro(x), esta(carba, l), esta(x, o), costados(l, o)]),
           ([], [seguro, seguro(lobo), seguro(repollo)]),

           ([x, l, n], [paso(x),
                            barco(l),
                            esta(x, l),
                            costados(l, n),
                            retract(esta(x, l)),
                            retract(barco(l)),
                            asserta(esta(x, n)),
                            asserta(barco(n)),
                            seguro]),
           ([l, n], [paso(none),
                            barco(l),
                            costados(l, n),
                            retract(barco(l)),
                            asserta(barco(n)),
                            seguro])],
   check(X, PROG, R).
