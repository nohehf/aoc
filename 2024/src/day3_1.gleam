import aoc
import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result

const day = 3

const part = 1

const example_input = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

pub fn main() {
  // let input = example_input
  let input = aoc.read_input(day)

  io.println_error(
    "Running challenge "
    <> aoc.challenge_name(day, part)
    <> "\n with input:\n"
    <> input,
  )

  let assert Ok(r) = regexp.from_string("mul\\((\\d{1,3}),(\\d{1,3})\\)")

  regexp.scan(r, input)
  |> list.map(fn(match) {
    let regexp.Match(_, matches) = match
    case matches {
      [o1, o2] -> {
        // NOTE: this is bad error handling
        let assert option.Some(s1) = o1
        let assert option.Some(s2) = o2
        aoc.stoi(s1) * aoc.stoi(s2)
      }
      _ -> panic as "invalid number of matches"
    }
  })
  |> int.sum
  |> io.debug
}
