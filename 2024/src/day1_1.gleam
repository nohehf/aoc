import aoc
import gleam/int
import gleam/io
import gleam/list
import gleam/string

const day = 1

const part = 1

// todo: we could use zip / unzip
pub fn get_lists(input: String) {
  input
  // get lines
  |> string.split(on: "\n")
  // split rows
  |> list.map(string.split(_, on: "   "))
  // build list tuple to return
  |> list.fold(#([], []), fn(lists, row_strings) {
    // assert we have two elements and covert to a tuple
    let #(s1, s2) = case row_strings {
      [s1, s2] -> #(s1, s2)
      _ -> panic as "we should have exactly two elements per row"
    }
    // convert to ints
    let assert Ok(s1) = int.parse(s1)
    let assert Ok(s2) = int.parse(s2)
    let #(l1, l2) = lists
    // prepend to result (order dosent matter)
    #([s1, ..l1], [s2, ..l2])
  })
}

const example = "3   4
4   3
2   5
1   3
3   9
3   3"

pub fn main() {
  let input = aoc.read_input(day)
  //let input = example
  io.println_error(
    "Running challenge " <> aoc.challenge_name(day, part) <> "\n with input:\n",
  )
  io.println_error(input)
  // split in 2 lists
  let res =
    input
    |> get_lists
    |> fn(t) {
      let #(l1, l2) = t
      // sort them
      let l1 = list.sort(l1, int.compare)
      let l2 = list.sort(l2, int.compare)
      // compute 1 to 1 diff
      list.map2(l1, l2, fn(a, b) { int.absolute_value(a - b) })
    }
    |> int.sum

  io.println("Result: " <> int.to_string(res))
}
