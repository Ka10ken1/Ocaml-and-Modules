
module type Set = sig
  type t
  val to_string : t -> string
end



module type Map = sig
  type key
  type value
  type t

  val empty : t
  val set : key -> value -> t -> t
  val get : key -> t -> value
  val get_opt : key -> t -> value option
  (* val clear : key -> t -> t *)
  val to_string : t -> string
end

module type OrderedSet = sig
  include Set
  val compare : t -> t -> int
end





module BTreeMap (K : OrderedSet) (V : Set) : Map with type key = K.t and type value = V.t = struct
  type key = K.t
  type value = V.t
  type t = Empty | Node of key * value * t * t

  let empty = Empty








  let rec set k v = function Empty -> Node (k, v, Empty, Empty)
    | Node (k', v', l, r) ->
      let diff = K.compare k k' in
      if diff < 0 then Node (k', v', set k v l, r)
      else if diff > 0 then Node (k', v', l, set k v r)
      else Node (k', v, l, r)








  let rec get_opt k = function Empty -> None
    | Node (k', v, l, r) ->
      let diff = K.compare k k' in
      if diff < 0 then get_opt k l
      else if diff > 0 then get_opt k r
      else Some v





  let get k m = match get_opt k m with Some v -> v
    | None -> raise Not_found




  
  let rec clear k = function Empty -> Empty
    | Node (k', v, l, r) ->
      let rec remove_max = function Empty -> failwith "unreachable"
        | Node (k, v, l, Empty) -> k, v, l
        | Node (k, v, l, r) -> let k', v', r' = remove_max r in k', v', Node (k, v, l, r')
      in
      let diff = K.compare k k' in
      if diff < 0 then Node (k', v, clear k l, r)
      else if diff > 0 then Node (k', v, l, clear k r)
      else if l = Empty then r
      else let max_k, max_v, max_l = remove_max l in
        Node (max_k, max_v, max_l, r)





  let rec to_list = function Empty -> []
    | Node (k, v, l, r) -> to_list l @ (k,v)::to_list r





  let to_string m =
    List.map (fun (k,v) -> K.to_string k ^ " -> " ^ V.to_string v) (to_list m)
    |> String.concat ", "
    |> Printf.sprintf "{ %s }"
end





module IntSet : OrderedSet with type t = int = struct
  type t = int
  let compare = compare
  let to_string = string_of_int
end





module StringSet : Set with type t = string = struct
  type t = string
  let to_string s = "\"" ^ s ^ "\""
end






module IntStringMap = BTreeMap(IntSet)(StringSet)
module IntIntMap = BTreeMap(IntSet)(IntSet)

let values = [2;4;15;22;6;7;8;31]

let m = List.fold_left (fun m k -> IntStringMap.set k (string_of_int (k * k)) m) IntStringMap.empty values
let _ = print_endline (IntStringMap.to_string m)



