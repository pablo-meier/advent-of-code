:- module advent.
:- interface.
:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int, list.
:- type elf_with_gifts ---> elf(id::int, num_presents::int).


:- pred elf_gift_sequence_upward(int::in, int::in, list(elf_with_gifts)::out) is det.
elf_gift_sequence_upward(Curr, Target, Lst) :-
  (Curr > Target -> Lst = []);
  elf_gift_sequence_upward(Curr + 1, Target, Tail),
  Lst = [elf(Curr, 1)|Tail].

:- pred elf_gift_sequence(int::in, list(elf_with_gifts)::out) is det.
elf_gift_sequence(Target, Lst) :-
  elf_gift_sequence_upward(1, Target, Lst).

:- pred elfswap(elf_with_gifts::in, elf_with_gifts::in, elf_with_gifts::out) is det.
elfswap(elf(Id1, NumItems1), elf(_, NumItems2), elf(Id1, NumItems1 + NumItems2)).


%% This is the meat, right here. 4 Params:
%%   First is the "processing" list. We go through it in pairs, handing off leftsies.
%%
%%   Second is the result list. We inspect to determine when to do another "round"
%%
%%   Third is the final result.

%% Terminate when the third element consists of one elf, and set the output to it.
:- pred consolidated_intermediate(list(elf_with_gifts)::in, list(elf_with_gifts)::in, elf_with_gifts::out) is semidet.
consolidated_intermediate([], [X|[]], X).

%% When the third element has many items and the second is out, "loop"
consolidated_intermediate([], [A,B|C], End) :-
  reverse([A,B|C], [X,Y|T]),
  consolidated_intermediate([X,Y|T], [], End).

%% If we're at the last element of the processing list, maybe compare to the first, drp if 0.
consolidated_intermediate([elf(Id, NumItems)|[]], [A|B], End) :-
  reverse([A|B], [X|T]),
  (NumItems = 0 -> consolidated_intermediate([X|T], [], End);
   elfswap(elf(Id, NumItems), X, Winner),
   consolidated_intermediate(T, [Winner], End)).

%% General case: Compare the two adjacents in processing list.
consolidated_intermediate([X,Y|Tail], Accum, End) :-
  elfswap(X, Y, NewWinner),
  consolidated_intermediate(Tail, [NewWinner|Accum], End).


:- pred consolidated(list(elf_with_gifts)::in, elf_with_gifts::out) is semidet.
consolidated(Input, Output) :-
  consolidated_intermediate(Input, [], Output).


:- pred elf_white_elephant(int::in, int::out) is semidet.
elf_white_elephant(NumElves, Winner) :-
  elf_gift_sequence(NumElves, ElfList),
  consolidated(ElfList, WinningElf),
  Winner = WinningElf^id.


main(!IO) :-
  (elf_white_elephant(3, X) ->
   io.write_string("Winner is: ", !IO),
   io.print(X, !IO),
   io.write_string("\n", !IO));
  io.write_string("We failed, comrades.", !IO).
