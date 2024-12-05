import aoc
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order.{type Order}
import gleam/result
import gleam/string

const day = 2

const part = 1

const exemple_input = "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

//--- Part Two ---
//The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.
//
//The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report. It's like the bad level never happened!
//
//Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.
//
//More of the above example's reports are now safe:
//
//7 6 4 2 1: Safe without removing any level.
//1 2 7 8 9: Unsafe regardless of which level is removed.
//9 7 6 2 1: Unsafe regardless of which level is removed.
//1 3 2 4 5: Safe by removing the second level, 3.
//8 6 4 4 1: Safe by removing the third level, 4.
//1 3 6 7 9: Safe without removing any level.
//Thanks to the Problem Dampener, 4 reports are actually safe!
//
//Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?

pub fn parse_input(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(row) {
    row
    |> string.split(" ")
    |> list.map(fn(d) {
      let assert Ok(n) = int.parse(d)
      n
    })
  })
}

fn is_valid_rec(line: List(Int), order: Option(order.Order)) {
  case line {
    // empty or one element list, return true
    [] | [_] -> True
    // two or more elements
    [n1, n2, ..tail] -> {
      // case 1, good
      {
        let o = Some(int.compare(n1, n2))
        // order
        { order == None || o == order }
        // diff
        && {
          let diff = int.absolute_value(n1 - n2)
          diff >= 1 && diff <= 3
        }
        // recursive call: check if the rest of the list, without n1, is valid
        && is_valid_rec([n2, ..tail], o)
      }
    }
  }
}

pub fn main() {
  // let input = exemple_input
  let input = aoc.read_input(day)

  io.println_error(
    "Running challenge "
    <> aoc.challenge_name(day, part)
    <> "\n with input:\n"
    <> input,
  )

  input
  |> parse_input
  // test on i + all combinations with one less element
  |> list.map(fn(i) { [i, ..list.combinations(i, list.length(i) - 1)] })
  // count the number of inputs, where at least 1 combination is valid
  // TODO: this is ugly in term of style, and probably the functions cascade (definin twice fn(combinations) can be avoided with panache, maybe with the `use` keyword
  // NOTE: This is also bad in term of performance and it could be optimized, but it is the easiest solution.
  |> list.count(fn(combinations) {
    list.any(combinations, fn(combinations) { is_valid_rec(combinations, None) })
  })
  |> io.debug
}
