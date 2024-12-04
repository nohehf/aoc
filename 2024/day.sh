#!/bin/bash

DAY_NO=$1
# if day_no is null or not in range 1-25
if [ -z $DAY_NO ] || [ $DAY_NO -lt 1 ] || [ $DAY_NO -gt 25 ]; then
    echo "Invalid day number"
    exit 1
fi
PART_NO=$2
# if chall no is null or not in range 1-2 set to 1
if [ -z $PART_NO ] || [ $PART_NO -lt 1 ] || [ $PART_NO -gt 2 ]; then
    PART_NO=1
fi

if [ ! -d src ]; then
    mkdir src
fi

if [ ! -d inputs ]; then
    mkdir inputs
fi

# if file already exists skip
if [ -f src/day${DAY_NO}_${PART_NO}.gleam ]; then
    echo "File src/day${DAY_NO}_${PART_NO}.gleam already exists"
    exit 1
fi

echo Creating src/day${DAY_NO}_${PART_NO}.gleam
cat <<EOF > src/day${DAY_NO}_${PART_NO}.gleam
import aoc
import gleam/io

const day = ${DAY_NO}

const part = ${PART_NO}

const exemple_input = ""

pub fn main() {
  let input = example_input
  // let input = aoc.read_input(day)

  io.println_error(
    "Running challenge "
    <> aoc.challenge_name(day, part)
    <> "\n with input:\n"
    <> input,
  )
  // TODO
EOF

touch inputs/${DAY_NO}_${PART_NO}.txt

echo "check https://adventofcode.com/2024/day/${DAY_NO}/input to fill inputs/${DAY_NO}_${PART_NO}.txt"
echo "check https://adventofcode.com/2024/day/${DAY_NO} for the problem"
