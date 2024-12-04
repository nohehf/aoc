# gleam2024

Advent of code 2024 attempt in gleam, written in neovim. I am very new to those two things and in exams, so I probably won't do much.

## Usage

- New day:

```sh
N = 1
cp template.gleam day${N}-1.gleam
wget https://adventofcode.com/2024/day/${N}/input inputs/${N}-1.txt
echo "check https://adventofcode.com/2024/day/${N}"
```

- Run:
`gleam run -m dayN-1.gleam`
