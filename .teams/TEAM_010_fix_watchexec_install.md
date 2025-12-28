# TEAM_010: Fix watchexec installation

## Task
Fix the error where `cargo install watchexec` fails because the binary has moved to `watchexec-cli`.

## Progress
- [x] Identified the cause: `watchexec` crate version 8+ is a library, binary is in `watchexec-cli`.
- [x] Update `install-rust.sh` to use `watchexec-cli`.
- [x] Verify if other tools need updates.
