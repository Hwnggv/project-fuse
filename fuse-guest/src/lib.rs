//! FUSE Guest Program Library
//!
//! This module contains the guest program that runs inside the RISC Zero zkVM
//! to execute compliance checkers and generate proofs.

#![no_std]

extern crate alloc;

pub mod checker;
pub mod checkers;

/// Main entry point for the guest program
/// Reads spec and system data from host, executes checker, commits result
pub fn main() {
    use risc0_zkvm::guest::env;
    // Execute the checker
    let result = checker::execute_checker();
    
    // Commit result to journal (public output)
    env::commit(&result);
}
