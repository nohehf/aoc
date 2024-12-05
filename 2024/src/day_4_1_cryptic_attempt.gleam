import aoc
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result

//--- Day 4: Ceres Search ---
//"Looks like the Chief's not here. Next!" One of The Historians pulls out a device and pushes the only button on it. After a brief flash, you recognize the interior of the Ceres monitoring station!
//
//As the search for the Chief continues, a small Elf who lives on the station tugs on your shirt; she'd like to know if you could help her with her word search (your puzzle input). She only has to find one word: XMAS.
//
//This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:
//
//
//..X...
//.SAMX.
//.A..A.
//XMAS.S
//.X....
//The actual word search will be full of letters instead. For example:
//
//MMMSXXMASM
//MSAMXMSMSA
//AMXSXMAAMM
//MSAMASMSMX
//XMASAMXAMM
//XXAMMXXAMA
//SMSMSASXSS
//SAXAMASAAA
//MAMMMXMMMM
//MXMXAXMASX
//In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:
//
//....XXMAS.
//.SAMXMS...
//...S..A...
//..A.A.MS.X
//XMASAMX.MM
//X.....XA.A
//S.S.S.S.SS
//.A.A.A.A.A
//..M.M.M.MM
//.X.X.XMASX
//Take a look at the little Elf's word search. How many times does XMAS appear?

const day = 4

const part = 1

const example_input = "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

const masked_input = "....XXMAS.
.SAMXMS...
...S..A...
..A.A.MS.X
XMASAMX.MM
X.....XA.A
S.S.S.S.SS
.A.A.A.A.A
..M.M.M.MM
.X.X.XMASX"

// I did try to solve this with regex lol, seemd fun
// observation
// given matrix size of L,C (C=4 for demo)
// in horizontal (XMAS), characters are separated by 0 chars
fn vertical_reg(c: Int) {
  let assert Ok(r) = regexp.from_string("XMAS")
  r
}

// in vertical:
// X...
// M...
// A...
// S...
// if we join lines:
// X...\nM...\nA...\nS
// characters are separated by C chars (3*"." and 1 * "\n")
// generalisation
// possible chars
const p = "XMAS"

// repeat possible char n times ([XMAS]{n})
fn pn(n: Int) {
  "[" <> p <> "]{" <> aoc.itos(n) <> "}"
}

// this looks well better unformatted:
//         "X" <> pn(c-1) <> "\n"
//      <> "M" <> pn(c-1) <> "\n"
//      <> "A" <> pn(c-1) <> "\n"
//      <> "S"

fn horizontal_reg(c: Int) {
  let assert Ok(r) =
    regexp.from_string(
      "X"
      <> pn(c - 1)
      <> "\n"
      <> "M"
      <> pn(c - 1)
      <> "\n"
      <> "A"
      <> pn(c - 1)
      <> "\n"
      <> "S",
    )
  r
}

// in diagonal right
// X...
// .M..
// ..A.
// ...S
// if we join lines
// X...\n.M..\n..A.\n...S
// lets fix P all possible chars P = [XMAS]
// pattern (as a pseudo regex) is XP{3}\nP{1}MP{2}\nP{2}AP{1}\nP{3}S
// generalization:      XP{C-1}\nP{C-3}MP{C-2}\nP{C-2}AP{C-3}\nP{C-1}S

//   "X" <> pn(c-1) <> "\n" <> pn(c-3) 
//<> "M" <> pn(c-2) <> "\n" <> pn(c-2)
//<> "A" <> pn(c-3) <> "\n" <> pn(c-1)
//<> "S"
fn diagonal_right_reg(c: Int) {
  "X"
  <> pn(c - 1)
  <> "\n"
  <> pn(c - 3)
  <> "M"
  <> pn(c - 2)
  <> "\n"
  <> pn(c - 2)
  <> "A"
  <> pn(c - 3)
  <> "\n"
  <> pn(c - 1)
  <> "S"
}

// for the diagonal left
// ...X.
// ..M..
// .A...
// S....

// pn(c-3) <> "X" <> pn(c - 4) <> "\n"
//<> "M" <> pn(c-2) <> "\n" <> pn(c-2)
//<> "A" <> pn(c-3) <> "\n" <> pn(c-1)
//<> "S"

// characters are separated by C + 1 chars (4 * "." and 1*\n)
// problem with this approach is "wrapping lines" for diagonals
// like
// .X..
// ..M.
// ...A
// S...
// should not be valid
// -> maybe the \n actually fixes this -> seems like it does

// other approach 

///
pub fn main() {
  //  let input = example_input
  // let input = aoc.read_input(day)
  let input = masked_input

  io.println_error(
    "Running challenge "
    <> aoc.challenge_name(day, part)
    <> "\n with input:\n"
    <> input,
  )
}
