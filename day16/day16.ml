open Printf

(* List.map and List.concat aren't tail recursive, and it's causing stack overflows
 * with my giant lists x_x *)
let safe_map f lst =
    let rec mp l accum =
        match l with
        [] -> List.rev accum
        | h::t -> mp t ((f h)::accum)
    in
    mp lst []


let safe_append l1 l2 =
    let rec sf fst snd acc =
        match (fst, snd) with
        ([], []) -> List.rev acc
        | (h::t, _) -> sf t snd (h::acc)
        | ([], h::t) -> sf [] t (h::acc)
    in
    sf l1 l2 []

let take n lst =
    let rec take_recur n lst accum =
        match (n, lst) with
        (0, _) -> List.rev accum
        | (_, h::t) -> take_recur (n - 1) t (h::accum)
        | _ -> failwith "Bad params to take"
    in
    take_recur n lst []


let flip(x) =
    match x with
    0 -> 1
    | _ -> 0


let fill_data chars max_length =
    let rec fill_data_recur c =
        if (List.length c) > max_length then
            take max_length c
        else
            fill_data_recur (safe_append (safe_append c [0]) (safe_map (fun n -> flip(n)) (List.rev c)))
    in
    fill_data_recur chars


let checksum_shrink digits =
    let rec checksum_shrink_recur digits accum =
        match digits with
        [] -> List.rev accum
        | (x :: (y :: t)) -> 
                if x == y then
                    checksum_shrink_recur t (1 :: accum)
                else
                    checksum_shrink_recur t (0 :: accum)
        | _ -> failwith "Uneven list for checksum to consider."
    in
    checksum_shrink_recur digits []


let rec checksum digits =
    let shrunken = checksum_shrink(digits) in
    if (List.length shrunken) mod 2 == 0 then
        checksum(shrunken)
    else
        shrunken


let final_checksum chars length =
    let filled = fill_data chars length in
    checksum filled

let () = print_string("Part 1\n")
let () = List.iter (printf "%d") (final_checksum [0;1;1;1;1;0;0;1;1;0;0;1;1;1;0;1;1] 272)

let () = print_string("\nPart 2\n")
let () = List.iter (printf "%d") (final_checksum [0;1;1;1;1;0;0;1;1;0;0;1;1;1;0;1;1] 35651584)

