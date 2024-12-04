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

//This example data contains six reports each containing five levels.
//
//The engineers are trying to figure out which reports are safe. The Red-Nosed reactor safety systems can only tolerate levels that are either gradually increasing or gradually decreasing. So, a report only counts as safe if both of the following are true:
//
//The levels are either all increasing or all decreasing.
//Any two adjacent levels differ by at least one and at most three.
//In the example above, the reports can be found safe or unsafe by checking those rules:
//
//7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
//1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
//9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
//1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
//8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
//1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.
//So, in this example, 2 reports are safe.
//
//Analyze the unusual data from the engineers. How many reports are safe?

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

pub fn main() {
  //let input = exemple_input
  let input = aoc.read_input(day)

  io.println_error(
    "Running challenge "
    <> aoc.challenge_name(day, part)
    <> "\n with input:\n"
    <> input,
  )

  input
  |> parse_input
  |> list.count(is_valid_rec(_, None))
  |> io.debug
}
