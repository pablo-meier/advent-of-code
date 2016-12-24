%% BUGS
%%  Removing the element doesn't put the head back where it's supposed to be.

:- module advent2.
:- interface.
:- import_module io.

:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int, list.
:- type elf_with_gifts ---> elf(id::int, num_presents::int).
:- type circular_list(T) ---> circular_list(front::list(T), back::list(T), length::int).


%% New Circular list from standard list
:- pred circular_list_from(list(T)::in, circular_list(T)::out) is det.
circular_list_from(In, Out) :-
  length(In, L),
  Out = circular_list(In, [], L).

%% Like "cons" behavior: appends an element, though not at the head, but one before it.
:- pred circular_list_addback(T::in, circular_list(T)::in, circular_list(T)::out) is det.
circular_list_addback(Elt, circular_list(Front, Back, Length), Output):-
  Output = circular_list(Front, [Elt|Back], Length + 1). 

%% Opposite of cons: splits a circular list into a head and tail.
:- pred circular_list_headtail(circular_list(T)::in, T::out, circular_list(T)::out) is det.
circular_list_headtail(circular_list([], Back, L), H, T) :-
  reverse(Back, Revved),
  circular_list_headtail(circular_list(Revved, [], L), H, T).

circular_list_headtail(circular_list([H|T], Back, L), H, Tail) :-
  Tail = circular_list(T, Back, L - 1).

%% Length. We store it "statefully" because otherwise ouch.
:- pred circular_list_length(circular_list(T)::in, int::out) is det.
circular_list_length(circular_list(_,_,X), X).


%% This is the meat this time. Uses our shmancy new circular list to remove an element, 
:- pred circular_list_nth_and_remove(circular_list(T)::in, int::in, circular_list(T)::out, T::out) is det.
circular_list_nth_and_remove(circular_list([], Back, L), Index, NewList, Element) :-
  reverse(Back, Revved),
  circular_list_nth_and_remove(circular_list(Revved, [], L), Index, NewList, Element).

circular_list_nth_and_remove(circular_list([H|T], Back, L), Index, NewList, Element) :-
  (Index = 0 -> Element = H, NewList = circular_list(T, Back, L - 1));
  circular_list_nth_and_remove(circular_list(T, [H|Back], L), Index - 1, NewList, Element).


:- pred cycle_to_replace(circular_list(T)::in, T::in, circular_list(T)::out) is semidet.
cycle_to_replace(circular_list([], Back, L), Elt, Result):-
  reverse(Back, Revved),
  cycle_to_replace(circular_list(Revved, [], L), Elt, Result).

cycle_to_replace(circular_list([H|T], Back, L), Elt, Result):-
  H = Elt -> Result = circular_list(T, Back, L - 1);
  cycle_to_replace(circular_list(T, [H|Back], L), Elt, Result).


:- pred elf_gift_sequence_upward(int::in, list(elf_with_gifts)::in, list(elf_with_gifts)::out) is det.
elf_gift_sequence_upward(Curr, Accum, Lst) :-
  (Curr = 0 -> Accum = Lst);
  elf_gift_sequence_upward(Curr - 1, [elf(Curr, 1)|Accum], Lst).

:- pred elf_gift_sequence(int::in, circular_list(elf_with_gifts)::out) is det.
elf_gift_sequence(Target, Circular) :-
  elf_gift_sequence_upward(Target, [], Lst),
  circular_list_from(Lst, Circular).

:- pred elfswap(elf_with_gifts::in, elf_with_gifts::in, elf_with_gifts::out) is det.
elfswap(elf(Id1, NumItems1), elf(_, NumItems2), elf(Id1, NumItems1 + NumItems2)).


:- pred across_circle_index(int::in, int::out) is det.
across_circle_index(Length, AcrossCircle) :-
  AcrossCircle is Length/2.


%% With our new circular list, this gets a fair bit easier.
%% Check length; if 1, return that elf.
%% If other, calculate the index of the opposite, find it and recurse.
:- pred consolidated(circular_list(elf_with_gifts)::in, elf_with_gifts::out) is semidet.
consolidated(Circular, End) :-
  circular_list_length(Circular, Length),
  circular_list_headtail(Circular, H, _),
  (Length = 1 -> End = H;
   across_circle_index(Length, AcrossCircle),
   circular_list_nth_and_remove(Circular, AcrossCircle, NewCircular, Removed),
   cycle_to_replace(NewCircular, H, FinalTail),
   elfswap(H, Removed, NewHead),
   circular_list_addback(NewHead, FinalTail, FinalAugmented),
   consolidated(FinalAugmented, End)).


:- pred elf_white_elephant(int::in, int::out) is semidet.
elf_white_elephant(NumElves, Winner) :-
  elf_gift_sequence(NumElves, ElfList),
  consolidated(ElfList, WinningElf),
  Winner = WinningElf^id.


main(!IO) :-
  (elf_white_elephant(3004953, X) ->
%  (elf_white_elephant(5, X) ->
%  (elf_gift_sequence(5, L), across_circle_index(5, Across), circular_list_nth_and_remove(L, Across, NL, Elt), cycle_to_replace(NL, elf(1,1), FinalTail), elfswap(elf(1,1), Elt, NewElf), circular_list_addback(NewElf,FinalTail,OneIteration), across_circle_index(4, A2), circular_list_nth_and_remove(OneIteration, A2, NL2, Elt2), cycle_to_replace(NL2, elf(2,1), FT2), elfswap(elf(2,1), Elt2, NE2), circular_list_addback(NE2, FT2, TwoIterations), across_circle_index(3, X) ->
   io.write_string("Winner is: ", !IO),
   io.print(X, !IO),
   io.write_string("\n", !IO));
  io.write_string("We failed, comrades.", !IO).
