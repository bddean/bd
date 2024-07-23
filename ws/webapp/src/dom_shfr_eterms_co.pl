:- module(_1,[],[utility(common),pillow,block,assertions,nativeprops,regtypes,fsyntax,dcg]).

dom(_1).

%% %% :- check pred dom_pillow(_A,_B)
%% %%    :: ( dom(_A), term(_B) ).

:- check test dom_pillow(D,P)
   : (D=text("hello"))
   => (P=verbatim("hi")).

:- check calls dom_pillow(_A,_B).

dom_pillow(text(S),verbatim(S)).


