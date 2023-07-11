# Ocaml-and-Modules

## Set and Map Modules

This project defines modules for sets and maps with various functionalities.

### Set Module

The Set module is defined with the following signature:

```ocaml
module type Set = sig
  type t
  val to_string : t -> string
end
```


### Map Module
The Map module is defined with the following signature:
```ocaml
module type Map = sig
  type key
  type value
  type t
  val empty : t
  val set : key -> value -> t -> t
  val get : key -> t -> value
  val get_opt : key -> t -> value option
  val to_string : t -> string
end
```


## Football Game Tournament Summary

This program analyzes the results of a round-robin football tournament and generates a summary table and list of goalscorers. The tournament data is represented as a list of tuples, where each tuple contains information about a game in the tournament.

## Tournament Table

The `table_and_scorers` function takes the list of game tuples as input and generates two lists:

1. The list of team summaries: Each team summary is a tuple of the form `(team, games_played, wins, draws, losses, goals_for, goals_against, points)`. The teams are sorted based on the following criteria:
   - Points: The teams are sorted in descending order of points earned.
   - Goal Difference: In case of a tie in points, teams are sorted in descending order of goal difference (`goals_for` - `goals_against`).
   - Goals For: If the goal difference is also tied, teams are sorted in descending order of goals scored.
   - Random Order: If teams have the same points, goal difference, and goals scored, their order is randomized.

2. The list of goalscorers: Each goalscorer is represented as a triple `(player, team, goals)`. The goalscorers are sorted based on the following criteria:
   - Goals: The goalscorers are sorted in descending order of goals scored.
   - Player Name: In case of a tie in goals scored, the players are sorted alphabetically by their names.

## Example

Assuming the team type is defined as follows:

```ocaml
type team = Arg | Sau | Mex | Pol | Por | Kor | Uru | Gha
