%% ----------------------------------------------------------------------
%%                                Rules
%% ----------------------------------------------------------------------


%%1.

is_loop(Event, Guard) :- transition(X, X, Event, Guard, _), ((Event \= null) ; (Guard \= null)).

%%2. 

all_loops(Set) :- findall([Event, Guard], is_loop(Event, Guard), Lst), list_to_set(Lst, Set). 

%%3.

is_edge(Event, Guard):- transition(_,_, Event, Guard, _). 

%%4. 

size(Length) :- findall([Event, Guard], is_edge(Event, Guard), L), length(L, Length).

%%5.

is_link(Event, Guard) :- transition(X, Y, Event, Guard, _), (X \= Y).

%%6.

allsuperstates(Set):- findall(State, (state(State), superstate(State,_)), Lst), list_to_set(Lst, Set). 

%%7.

ancestor(Ancestor, Descendant):- superstate(Ancestor, Descendant); superstate(Ancestor, AnotherState), ancestor(AnotherState, Descendant). 

%%8. 

inheritss_transitions(State, List) :- findall(transition(Super, Destination,Event,Guard,Actions), superstate(Super, State), L1),findall(transition(Source, Super,Event1,Guard1, Actions1), superstate(Super, State), L2), append(L1, L2, List).  

%%9. 

all_states(L):- findall(State, state(State), L). 

%%10. 

all_init_states(L):- findall(State, initial(State,_), L). 

%%11. 

get_starting_state(State):- initial(State, null). 

%%12.

state_is_reflexive(State):- state(State), transition(State, State, _, _, _).

%%13.

graph_is_reflexive :- forall(state(State), state_is_reflexive(State)). 


%%14. 

get_guards(Ret):- findall(Guards, transition(_,_, _, Guards, _), Lst), list_to_set(Lst, Ret). 


%%15. 

get_events(Ret):- findall(Events, transition(_,_, Events, _,_), Lst), list_to_set(Lst, Ret). 


%%16. 

get_actions(Ret) :- findall(Actions, transitions(_,_,_,_, Actions), Lst), list_to_set(Lst, Ret). 


%%17. 

get_only_guarded(Ret):- findall([Source, Destination], ((transition(Source, Destination, null, Guard, null)), (Guard \= null)), Lst), list_to_set(Lst, Ret). 


%%18. 

legal_events_of(State, L):- findall([Event, Guard], ((transition(_, State, Event, Guard, _)); (transition(State, _, Event, Guard, _))), L). 

