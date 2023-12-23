#!/bin/bash

set -euo pipefail
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"

if [[ "$(rustup toolchain list)" =~ "riscv32em-nightly-2023-04-05-r0-x86_64-unknown-linux-gnu" ]]; then
    export RV32E_TOOLCHAIN="riscv32em-nightly-2023-04-05-r0-x86_64-unknown-linux-gnu"
else
    curl -L --output /tmp/rust-riscv32em-nightly-2023-04-05-r0-x86_64-unknown-linux-gnu.tar.xz "https://github.com/koute/rustc-rv32e/releases/download/nightly-2023-04-05-r0/rust-riscv32em-nightly-2023-04-05-r0-x86_64-unknown-linux-gnu.tar.xz"
    tar -C /tmp -xf /tmp/rust-riscv32em-nightly-2023-04-05-r0-x86_64-unknown-linux-gnu.tar.xz
    mkdir -p ~/.rustup/toolchains
    mv /tmp/rust-riscv32em-x86_64-unknown-linux-gnu/riscv32em-nightly-2023-04-05-r0-x86_64-unknown-linux-gnu ~/.rustup/toolchains/
    export RV32E_TOOLCHAIN="riscv32em-nightly-2023-04-05-r0-x86_64-unknown-linux-gnu"
fi

function build_example () {
    output_path="output/$1.polkavm"
    current_dir=$(pwd)

    echo "> Building: '$1' (-> $output_path)"
    RUSTFLAGS="-C relocation-model=pie -C link-arg=--emit-relocs -C link-arg=-T.cargo/memory.ld --remap-path-prefix=$(pwd)= --remap-path-prefix=$HOME=~" cargo build -q --release --bin $1 -p $1
    cd ..
    cargo run -q -p polkatool link --run-only-if-newer -s guest-programs/target/riscv32em-unknown-none-elf/release/$1 -o guest-programs/$output_path
    cd $current_dir
}

build_example "example-hello-world"
