import gleam/int
import gleam/io
import gleam/string
import simplifile

// shared functions
pub fn read_input(day: Int) -> String {
  let path = "./inputs/" <> int.to_string(day) <> ".txt"
  let assert Ok(input) = simplifile.read(path)
  let input = case string.length(input) {
    0 -> panic as "Empty input file !"
    _ -> input
  }
  input
}

pub fn challenge_name(day: Int, part: Int) -> String {
  int.to_string(day) <> "_" <> int.to_string(part)
}

pub fn main() {
  io.println(
    "Sir that's a wendy's! try running one of the days eg.\n gleam run -m day1_1",
  )
}
