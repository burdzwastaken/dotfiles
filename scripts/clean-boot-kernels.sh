#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: clean-boot-kernels.sh [KEEP_GENERATIONS]

Safely recover space from mirrored NixOS GRUB EFI partitions.

Default behavior is a dry run. Set DELETE=1 to remove unreferenced files:

  ./scripts/clean-boot-kernels.sh 5
  DELETE=1 ./scripts/clean-boot-kernels.sh 5

The script:
  - deletes old NixOS system generations beyond KEEP_GENERATIONS
  - runs nix-collect-garbage -d
  - removes interrupted *.tmp files from /boot*/kernels
  - keeps files referenced by GRUB configs
  - keeps the currently running kernel version
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

keep_generations="${1:-5}"
delete="${DELETE:-0}"

if ! [[ "$keep_generations" =~ ^[0-9]+$ ]] || [[ "$keep_generations" -lt 1 ]]; then
  echo "KEEP_GENERATIONS must be a positive integer" >&2
  exit 2
fi

if [[ "$delete" != "0" && "$delete" != "1" ]]; then
  echo "DELETE must be 0 or 1" >&2
  exit 2
fi

current_kernel="$(uname -r)"
keep_file="$(mktemp)"
trap 'rm -f "$keep_file"' EXIT

echo "Current kernel: $current_kernel"
echo "Keeping last $keep_generations system generations"

if [[ "$delete" == "1" ]]; then
  echo "Mode: delete"
else
  echo "Mode: dry run. Set DELETE=1 to delete unreferenced files."
fi

sudo nix-env -p /nix/var/nix/profiles/system --delete-generations "+$keep_generations"
sudo nix-collect-garbage -d

# Keep files still referenced by installed GRUB configs. These names match the
# /boot/kernels/<store-hash>-linux-<version>-bzImage and initrd files exactly.
for cfg in /boot/grub/grub.cfg /boot2/grub/grub.cfg; do
  [[ -f "$cfg" ]] || continue
  grep -oE '/kernels/[^[:space:]]+' "$cfg" | xargs -r -n1 basename
done | sort -u > "$keep_file"

for boot in /boot /boot2; do
  [[ -d "$boot/kernels" ]] || continue

  echo "Cleaning temp files in $boot/kernels"
  if [[ "$delete" == "1" ]]; then
    sudo rm -f "$boot"/kernels/*.tmp
  else
    find "$boot/kernels" -maxdepth 1 -type f -name '*.tmp' -print | sed 's/^/would delete: /'
  fi

  echo "Checking unreferenced kernels in $boot/kernels"
  while IFS= read -r path; do
    base="$(basename "$path")"

    # Never delete the running kernel/initrd by version. This preserves the
    # currently booted fallback even if old GRUB config references are stale.
    if [[ "$base" == *"$current_kernel"* ]]; then
      continue
    fi

    if grep -Fqx "$base" "$keep_file"; then
      continue
    fi

    if [[ "$delete" == "1" ]]; then
      echo "delete: $path"
      sudo rm -f "$path"
    else
      echo "would delete: $path"
    fi
  done < <(find "$boot/kernels" -maxdepth 1 -type f ! -name '*.tmp' | sort)
done

df -h /boot /boot2 2>/dev/null || df -h /boot
