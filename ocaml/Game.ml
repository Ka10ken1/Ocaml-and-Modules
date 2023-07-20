type team = Arg | Sau | Mex | Pol | Por | Kor | Uru | Gha

let number_of_games lst team =
  List.length (List.filter(fun (x,_,y,_) -> x =team || y =team) lst) ;;

let number_of_wins lst team =
  let tuples = List.filter(fun (x,_,y,_) -> x =team || y =team) lst in
  let rec helper tupls =
  match tupls with
  | [] -> 0
  | (x,lst1,y,lst2)::rest -> if team = x && List.length lst1> List.length lst2 then 1 + helper rest
                             else if team =y && List.length lst2> List.length lst1 then 1+helper rest
                             else helper rest
                            in helper tuples
let number_of_draws lst team =
  let tuples = List.filter(fun (x,_,y,_) -> x =team || y =team) lst in
  let rec helper tupls =
  match tupls with
  | [] -> 0
  | (x,lst1,y,lst2)::rest -> if team = x && List.length lst1= List.length lst2 then 1 + helper rest
                             else if team =y && List.length lst2= List.length lst1 then 1+helper rest
                             else helper rest
                            in helper tuples
let number_of_loses lst team =
   let tuples = List.filter(fun (x,_,y,_) -> x =team || y =team) lst in
     let rec helper tupls =
       match tupls with
         | [] -> 0
         | (x,lst1,y,lst2)::rest -> if team = x && List.length lst1< List.length lst2 then 1 + helper rest
                                    else if team =y && List.length lst2< List.length lst1 then 1+helper rest
                                    else helper rest
                                    in helper tuples

let goals_for_and_against lst team =
  let rec helper tuples g_for g_against =
    match tuples with
    | [] -> (g_for, g_against)
    | (x, lst1, y, lst2) :: rest ->
      if team = x then
        helper rest (g_for + List.length lst1) (g_against + List.length lst2)
      else
        helper rest (g_for + List.length lst2) (g_against + List.length lst1)
  in
  helper (List.filter (fun (x, _, y, _) -> x = team || y = team) lst) 0 0



  let process lst team =
    let games = number_of_games lst team in
    let wins = number_of_wins lst team in
    let draws = number_of_draws lst team in
    let losses = number_of_loses lst team in
    let goals_for, goals_against = goals_for_and_against lst team in
    let points = wins * 3 + draws in
    (team, games, wins, draws, losses, goals_for, goals_against, points)
  


let first_list lst =
  let teams = [Arg; Sau; Mex; Pol; Por; Kor; Uru; Gha] in
  let summaries = List.map (process lst) teams in
  let filter =
    List.filter(fun (_, games, _, _, _, _, _, _) -> games >= 1) summaries
  in
  List.sort(fun (t1, _, _, _, _, gf1, ga1, p1) (t2, _, _, _, _, gf2, ga2, p2) ->
      if p1 <> p2 then
        compare p2 p1
      else
        let gd1 = gf1 - ga1 in
        let gd2 = gf2 - ga2 in
        if gd1 <> gd2 then
          compare gd2 gd1
        else
          compare gf2 gf1)
    filter


let scorer_names lst =
  let rec extract_scorers games acc =
    match games with
    | [] -> acc
    | (_, scorers1, _, scorers2) :: rest ->
      extract_scorers rest (List.append acc  (List.append scorers1  scorers2))
  in
  List.sort_uniq String.compare (extract_scorers lst [])  (* already sorting alphabetically and removing duplicates *)

let scorer_goals lst player =
  let rec count_goals games count =
    match games with
    | [] -> count
    | (_, s1, _, s2) :: rest ->
      let goals1 = List.length (List.filter (fun scorer -> scorer = player) s1) in
      let goals2 = List.length (List.filter (fun scorer -> scorer = player) s2) in
      count_goals rest (count + goals1 + goals2)
  in
  count_goals lst 0

let find_team_for_player lst player =
  let rec helper games =
    match games with
    | [] -> raise Not_found
    | (t1, s1, _, _) :: rest when List.mem player s1 -> t1 (* check is list contans player with List.mem *)
    | (_, _, t2, s2) :: rest when List.mem player s2 -> t2
    | _ :: rest -> helper rest
  in
  helper lst

  let second_list lst =
    let players = scorer_names lst in
    let goals_and_teams = List.map (fun p -> (p, find_team_for_player lst p, scorer_goals lst p)) players in
    let cleaned_goals_and_teams = List.map (fun (player, team, goals) -> (player, team, goals)) goals_and_teams in
    List.sort (fun (_, _, g1) (_, _, g2) -> 
      compare g2 g1
      ) cleaned_goals_and_teams
  


let table_and_scorers lst = (first_list lst,second_list lst);;
