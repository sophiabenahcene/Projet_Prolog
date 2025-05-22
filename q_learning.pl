
:- dynamic lesPetitesLoutres_q_value/3, lesPetitesLoutres_visite/2, lesPetitesLoutres_epsilon/1.


lesPetitesLoutres_alpha(0.1).
lesPetitesLoutres_gamma(0.9).
lesPetitesLoutres_epsilon(1.0).
lesPetitesLoutres_epsilon_min(0.05).
lesPetitesLoutres_epsilon_reduc(0.995).

lesPetitesLoutres_actions([1,2,3,4,5]).
lesPetitesLoutres_val_defaut(0).

lesPetitesLoutres_get_q(Etat,Action,Q):- lesPetitesLoutres_q_value(Etat,Action,Q),!.
lesPetitesLoutres_get_q(Etat,Action,0.0):- assertz(lesPetitesLoutres_q_value(Etat,Action,0.0)).


lesPetitesLoutres_choix_action(Etat, Action) :-
    lesPetitesLoutres_epsilon(E),
    lesPetitesLoutres_epsilon_min(Em),
    lesPetitesLoutres_epsilon_reduc(Ed),
    lesPetitesLoutres_actions(AList),
    random(R),
    lesPetitesLoutres_choisir_action(E, R, AList, Etat, Action),
    lesPetitesLoutres_maj_epsilon(E, Em, Ed).

lesPetitesLoutres_choisir_action(E, R, AList,_, Action) :-
    R < E,
    random_member(Action, AList), !.

lesPetitesLoutres_choisir_action(_, _, AList, Etat, Action) :-
    findall(Q-A, (member(A, AList), lesPetitesLoutres_get_q(Etat, A, Q)), Paires),
    keysort(Paires, L),
    reverse(L, [_-Action | _]).

lesPetitesLoutres_maj_epsilon(E, Em, Ed) :-
    E > Em,
    E1 is max(Em, E * Ed),
    retractall(lesPetitesLoutres_epsilon(_)),
    assertz(lesPetitesLoutres_epsilon(E1)), !.

lesPetitesLoutres_maj_epsilon(_, _, _).

% Mise à jour Q-learning
lesPetitesLoutres_ajuster_q(S,A,R,S2):-
  lesPetitesLoutres_get_q(S,A,Q0), lesPetitesLoutres_actions(AList),
  findall(Qn,(member(A2,AList),lesPetitesLoutres_get_q(S2,A2,Qn)),Qs), max_list(Qs,MaxQ),
  lesPetitesLoutres_alpha(Al), lesPetitesLoutres_gamma(G), TD is R + G*MaxQ - Q0, Qnew is Q0 + Al*TD,
  retractall(lesPetitesLoutres_q_value(S,A,_)), assertz(lesPetitesLoutres_q_value(S,A,Qnew)).

lesPetitesLoutres_etat_depuis_historique(Historique, Etat) :-
  lesPetitesLoutres_val_defaut(D),
  findall(Coup, (nth1(I, Historique, [_, Coup]), I =< 3), CoupsRecents),
  length(CoupsRecents, L),
  ( L < 3 -> Manquant is 3 - L, length(Z, Manquant), maplist(=(D), Z), append(CoupsRecents, Z, CoupsFinal)
  ; CoupsFinal = CoupsRecents ),
  Etat = CoupsFinal.

joue(lesPetitesLoutres,Hist,Action):-
   lesPetitesLoutres_etat_depuis_historique(Hist,S),
   ( retract(lesPetitesLoutres_visite(PS,PA))
  ->  PS=[Prev|_],
      score(PA,Prev,Hist,Rew,_),
      lesPetitesLoutres_ajuster_q(PS,PA,Rew,S)
  ;   true ),
    lesPetitesLoutres_choix_action(S,Action),
    assertz(lesPetitesLoutres_visite(S,Action)).






























