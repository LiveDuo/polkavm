#!/bin/bash

POLKAVM_TRACE_EXECUTION=1 POLKAVM_ALLOW_INSECURE=1 POLKAVM_BACKEND=interpreter cargo run --target=x86_64-apple-darwin -p hello-world-host
