//! FUSE Guest Program Entry Point
//!
//! This is the main entry point for the RISC Zero guest program.

#![no_main]
#![no_std]

extern crate alloc;

use risc0_zkvm::guest::env;
use fuse_guest::checker;

risc0_zkvm::guest::entry!(main);

fn main() {
    // Execute the checker
    let result = checker::execute_checker();
    
    // Commit result to journal (public output)
    env::commit(&result);
}
