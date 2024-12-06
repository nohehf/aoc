import aoc
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string

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

// Possible chars
type C {
  X
  M
  A
  S
  // Filler character
  O
}

// Pattern we want to match
const pattern = [X, M, A, S]

type M =
  List(List(C))

fn str_to_c_list(str: String) -> List(C) {
  str
  |> string.split("")
  |> list.fold([], fn(acc, c) {
    case c {
      "X" -> [X, ..acc]
      "M" -> [M, ..acc]
      "A" -> [A, ..acc]
      "S" -> [S, ..acc]
      c ->
        case string.length(c) {
          1 -> [O, ..acc]
          _ -> panic as "Unreachable, should be a single char"
        }
    }
  })
  |> list.reverse
}

fn input_to_mat(input: String) -> M {
  input
  |> string.split("\n")
  |> list.map(str_to_c_list)
}

fn list_starts_with(l, p) {
  case l, p {
    // ok
    _, [] -> True
    // ko
    [], _ -> False
    [l1, ..lt], [p1, ..pt] -> {
      l1 == p1 && list_starts_with(lt, pt)
    }
  }
}

fn list_count_occurences(l, p) {
  case l {
    [] -> 0
    [_, ..q] -> {
      case list_starts_with(l, p) {
        True -> 1
        False -> 0
      }
      + list_count_occurences(q, p)
    }
  }
}

// count horizontal XMAS occurences
fn count_horizontal(m: M) {
  m
  |> list.map(list_count_occurences(_, pattern))
  |> int.sum
}

// wrap 1: [a, b, c] -> [b, c, a]
// no-wrap 1: [a, b, c] -> [b, c, x]
fn list_shift_replace(l, n, x) {
  case l, n {
    [], _ -> []
    _, n if n == 0 -> l
    [_, ..t], n -> list_shift_replace(t, n - 1, x) |> list.append([x])
  }
}

// Okaaaaay so it turns out we DO want to match wrapping values, making this SO much easier. My initial regex solution could have easily worked TT. IMO the example was not good not precising this.
// OR NOT ??
fn list_shift_wrap(l, n) {
  case l, n {
    [], _ -> []
    _, n if n == 0 -> l
    [e, ..t], n -> list_shift_wrap(t, n - 1) |> list.append([e])
  }
}

//X...
//.M..
//..A.
//...S
fn count_right_diag(m: M) {
  //X...
  //M..O
  //A.OO
  //SOOO
  let verticalized =
    list.index_fold(m, [], fn(new_mat, l, i) {
      [list_shift_replace(l, i % list.length(pattern), O), ..new_mat]
    })
    |> list.reverse

  // XMAS
  verticalized |> list.transpose |> count_horizontal
}

fn mat_flip_h(m) {
  m |> list.map(list.reverse)
}

fn mat_flip_v(m) {
  m |> list.reverse
}

fn count_quarter(m) {
  count_horizontal(m) + count_right_diag(m)
}

// rot 90 deg clockwise: transpose then reverse rows
fn mat_rot(m) {
  m
  |> list.transpose
  |> list.map(list.reverse)
}

fn count(m) {
  // count for each rotation
  [m, mat_rot(m), mat_rot(mat_rot(m)), mat_rot(mat_rot(mat_rot(m)))]
  |> list.map(count_quarter)
  |> int.sum
}

fn debug_mat(m) {
  list.map(m, io.debug)
}

const day = 4

pub fn main() {
  let input = example_input

  //let input = aoc.read_input(day)

  let assert False =
    [M, M, M, S, X, X, M, A, S, M]
    |> list_starts_with([M, M, M, S, A])

  let assert False =
    [M, M, M, S, X, X, M, A, S, M]
    |> list_starts_with([M, M, M, S, X])

  // Ok
  [M, M, X, M, A, S, M, S, X, X, M, A, S, M]
  |> list_count_occurences([X, M, A, S])
  |> io.debug

  input
  |> input_to_mat
  |> debug_mat
  |> count
  |> io.debug
}
