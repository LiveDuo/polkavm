#!/bin/bash

cd guest-programs

echo "> Building: example-hello-world"

export RUSTFLAGS="-C relocation-model=pie -C link-arg=--emit-relocs -C link-arg=-T.cargo/memory.ld --remap-path-prefix=$(pwd)= --remap-path-prefix=$HOME=~"

cargo build -q --release --bin example-hello-world -p example-hello-world
# cargo run -q -p polkatool link --run-only-if-newer -s guest-programs/target/riscv32em-unknown-none-elf/release/$1 -o guest-programs/output/example-hello-world.polkavm
