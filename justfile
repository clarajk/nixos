set shell := ["bash", "-euo", "pipefail", "-c"]
set dotenv-load := false

flake := justfile_directory()

# Show available recipes when running `just` without arguments.
default:
    @just --list

# Build and activate a host configuration.
rebuild machine:
    sudo nixos-rebuild switch --flake "{{flake}}#{{machine}}"

# Build without activating anything.
build machine:
    nixos-rebuild build --flake "{{flake}}#{{machine}}"

# Build and activate temporarily without adding a bootloader entry.
test machine:
    sudo nixos-rebuild test --flake "{{flake}}#{{machine}}"

# Validate the entire flake.
check: fmt
    nix flake check "{{flake}}"

# Format the flake using the formatter configured in the flake.
fmt:
    nix fmt "{{flake}}"

# Update every flake input (including Rust toolchain).
update:
    nix flake update --flake "{{flake}}"
    rustup update

# Update one specific input.
update-input input:
    nix flake update "{{input}}" --flake "{{flake}}"

# Lint all nix files in the repository.
lint:
    -statix check .
    -deadnix .

# Fix all lint issues automatically.
lint-fix:
    statix fix .
    deadnix --edit .