:- module advent.
:- interface.
:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int, list, maybe.
:- type elf_with_gifts ---> elf(id::int, num_presents::int).



:- pred elf_gift_sequence(int::in, list(elf_with_gifts)::out) is det.
elf_gift_sequence(Num, Lst) :-
  (Num = 0 -> Lst = []);
  elf_gift_sequence(Num - 1, Tail),
  Lst = [elf(Num, 1)|Tail].


:- pred elfswap(elf_with_gifts::in, elf_with_gifts::in, maybe(elf_with_gifts)::out) is det.
elfswap(elf(Id1, NumItems1), elf(_, NumItems2), Resp) :-
  (NumItems1 = 0 -> Resp = no);
  Resp = yes(elf(Id1, NumItems1 + NumItems2)).


%% This is the meat, right here. 4 Params:
%%   First is the first element of the initial list after they've made their move. They
%%   are needed to simulate a circular list when the second param has one element left.
%%
%%   Second is the "processing" list. We go through it in pairs, handing off leftsies.
%%
%%   Third is the result list. We inspect to determine when to do another "round"
%%
%%   Fourth is the final result.

%% Terminate when the third element consists of one elf, and set the output to it.
:- pred consolidated_intermediate(elf_with_gifts::in, list(elf_with_gifts)::in, list(elf_with_gifts)::in, elf_with_gifts::out) is semidet.
consolidated_intermediate(_, [], [X|[]], X).

%% When the third element has many items and the second is out, "loop"
consolidated_intermediate(_, [], [X,Y|T], End) :-
  (elfswap(X, Y, yes(NewFirstElf)) ->
   consolidated_intermediate(NewFirstElf, T, [NewFirstElf], End));
  consolidated_intermediate(Y, T, [Y], End).

%% If we're at the last element of the processing list, compare to the first
consolidated_intermediate(Y, [X|[]], Accum, End) :-
  (elfswap(X, Y, yes(Winner)) ->
   consolidated_intermediate(Winner, [], [Winner|Accum], End));
  consolidated_intermediate(Y, [], Accum, End).

%% General case: Compare the two adjacents in processing list.
consolidated_intermediate(First, [X,Y|Tail], Accum, End) :-
  (elfswap(X,Y, yes(NewWinner)) ->
   consolidated_intermediate(First, Tail, [NewWinner|Accum], End));
  Skipped = [Y|Tail],
  consolidated_intermediate(First, Skipped, Accum, End).


:- pred consolidated(list(elf_with_gifts)::in, elf_with_gifts::out) is semidet.
consolidated([X,Y|T], Output) :-
  elfswap(X, Y, yes(NewFirstElf)),
  consolidated_intermediate(NewFirstElf, T, [NewFirstElf], Output).


:- pred elf_white_elephant(int::in, int::out) is semidet.
elf_white_elephant(NumElves, Winner) :-
  elf_gift_sequence(NumElves, ElfList),
  consolidated(ElfList, WinningElf),
  Winner = WinningElf^id.


main(!IO) :-
  (elf_white_elephant(5, X) ->
   io.write_string("Winner is: ", !IO),
   io.write_int(X, !IO),
   io.write_string("\n", !IO));
  io.write_string("We failed, boys.", !IO).
