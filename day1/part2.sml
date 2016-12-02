datatype orientation = North | East | South | West
datatype direction = Right | Left

type instruction = (direction * int)
type location = (int * int)
type status = (orientation * location * location list list)

fun turn(orient: orientation, d: direction): orientation =
  case (orient,d) of
       (North, Right) => East
     | (East, Right) => South
     | (South, Right) => West
     | (West, Right) => North
     | (North, Left) => West
     | (West, Left) => South
     | (South, Left) => East
     | (East, Left) => North


fun move(orient: orientation,
         magnitude: int,
         l: location,
         accum: location list): (location * location list) =
  case magnitude of
    0 => (l, List.rev(accum))
    | _ => 
      let 
        val new_loc =  case (orient, l) of
          (North, (x,y)) => (x, y + 1)
        | (East, (x,y)) => (x + 1, y)
        | (South,(x,y)) => (x, y - 1)
        | (West, (x,y)) => (x - 1, y)
      in
        move(orient, magnitude - 1, new_loc, new_loc::accum)
      end


fun process_instruction(i: instruction, s: status): status =
  let
    val (direction, magnitude) = i
    val (orient, loc, visited) = s
    val new_orientation = turn(orient, direction)
    val (new_loc, accumed) = move(new_orientation, magnitude, loc, [])
  in
    (new_orientation, new_loc, accumed::visited)
  end


fun in_list(_, []) = false
  | in_list(x, h::t) =
  case x = h of
       true => true
     | false => in_list(x,t)

fun first_repeated([]) = (0,0)
  | first_repeated(h::t) =
  case in_list(h,t) of
       true => h
     | false => first_repeated(t)


fun manhattan_distance((x,y): location): int =
  abs(x) + abs(y)


fun process_list(loi : instruction list): int =
  let
    val initial_status = (North, (0,0), [])
    val (_, _, visited_locs) = foldl(process_instruction)(initial_status)(loi)
  in
    manhattan_distance(first_repeated((0,0)::List.concat(List.rev(visited_locs))))
  end


fun is_delimiter(#",") = true
  | is_delimiter(#" ") = true
  | is_delimiter(_) = false


fun char_to_direction(#"R") = Right
  | char_to_direction(_) = Left

fun safe_explode(s:string): char * char list =
  case String.explode(s) of
       dir::mag => (dir, mag)
     | [] => (#"R", [#"0"])

fun safe_implode_to_int(cl: char list): int =
  case Int.fromString(String.implode(cl)) of
       NONE => 0
     | SOME x => x

fun get_single_line(ins): string =
    case TextIO.inputLine ins of
         SOME line => line
       | NONE => ""

fun token_to_instruction(s:string): instruction =
  let
    val (dir, mag) = safe_explode(s)
    val mag_as_int = safe_implode_to_int(mag)
  in
    (char_to_direction(dir), mag_as_int)
  end

 
fun line_to_instruction_list(s: string): instruction list =
  let
    val tk_list = String.tokens(is_delimiter)(s)
  in
    map(token_to_instruction)(tk_list)
  end


fun read_input(s: string): instruction list =
  let
    val ins = TextIO.openIn s
    val line = get_single_line(ins)
    val _ = TextIO.closeIn ins
  in
    line_to_instruction_list(line)
  end

val _ = print(Int.toString(process_list(read_input("input.txt"))))
