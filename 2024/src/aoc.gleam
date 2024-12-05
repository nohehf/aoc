import gleam/int
import gleam/io
import gleam/string
import simplifile

// shared functions

pub fn read_custom_input(name: String) {
  let path = "./inputs/" <> name <> ".txt"
  let assert Ok(input) = simplifile.read(path)
  let input = case string.length(input) {
    0 -> panic as "Empty input file !"
    _ -> input
  }
  io.println("Reading:" <> path)
  input
}

pub fn read_input(day: Int) -> String {
  read_custom_input(itos(day))
}

pub fn challenge_name(day: Int, part: Int) -> String {
  int.to_string(day) <> "_" <> int.to_string(part)
}

/// unsafe string to int
pub fn stoi(s) {
  let assert Ok(i) = int.parse(s)
  i
}

pub fn itos(i) {
  int.to_string(i)
}

pub fn main() {
  io.println(
    "Sir that's a wendy's! try running one of the days eg.\n gleam run -m day1_1",
  )
}
