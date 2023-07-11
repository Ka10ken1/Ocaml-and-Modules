module type Readable = sig
  type t
  type arg
  val begin_read : arg -> t
  val end_read : t -> unit
  val at_end : t -> bool
  val read_line : t -> (t * string)
end

module ReadableString :Readable with  type arg = string = struct
  type t = string

  type arg = string

  let begin_read a = a

  let end_read _ = ()

  let at_end t = String.length t =0

  let read_line t =
    if at_end t then (t,"")
    else
      let i = try String.index t '\n' with Not_found -> String.length t in
      let line = String.sub t 0 i in
      let rest  = if i+1 >= String.length t then "" else String.sub t (i+1) (String.length t -i -1)
     in (rest,line) 


    
end

module ReadableFile : Readable with  type arg = string = struct

type t = in_channel

type arg = string

let begin_read file = open_in file

let end_read file = close_in file

let at_end file  = 
  let pos = pos_in file in
  let at_end  = try input_line file |> ignore;false with End_of_file -> true in
  seek_in file pos;at_end

let read_line file =  try (file,input_line file) with
  | End_of_file -> raise End_of_file
  | Sys_error err -> failwith "something"

end

module Reader (R: Readable) = struct
  include R

  let  read_all t =
    let rec aux acc t =
      if at_end t then 
        let a =
           if String.length acc >0
             then String.sub acc 0 (String.length acc -1)
           else "" in (end_read t,a)
      else
        let t', line = read_line t in
        aux (acc ^ line ^ "\n") t'
    in
    aux "" t
  
end


