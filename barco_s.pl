
:- [pinp].

solve(X, R) :-
   X = [paso(_), paso(_), paso(_), paso(_), paso(_), paso(_), paso(_), esta(repollo, derecha), esta(lobo, derecha), esta(carba, derecha)],
   PROG = [([], [barco(izquierda)]),
           ([], [esta(carba, izquierda)]), ([], [esta(lobo, izquierda)]), ([], [esta(repollo, izquierda)]),

           ([], [costados(izquierda, derecha)]), ([], [costados(derecha, izquierda)]),
           ([], [comer(lobo, repollo)]), ([], [comer(repollo, lobo)]),

           ([x, l, n], [movimiento(x),
                            barco(l),
                            esta(x, l),
                            costados(l, n),
                            retract(esta(x, l)),
                            retract(barco(l)),
                            asserta(esta(x, n)),
                            asserta(barco(n))]),
           ([], [paso(carba), movimiento(carba)]),
           ([a, b, l, o], [paso(a),
                             comer(a, b),
                             esta(carba, l),
                             costados(l, o),
                             esta(b, o),
                             movimiento(a)]),
           ([l, o, x, n], [paso(none),
                             esta(carba, l),
                             costados(l, o),
                             esta(lobo, o),
                             esta(repollo, o),
                             barco(x),
                             costados(x, n),
                             retract(barco(x)),
                             asserta(barco(n))])],
   check(X, PROG, R).
