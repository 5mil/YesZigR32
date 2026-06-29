# YesZigR32 Changelog

## [0.2.1] — 2026-06-28

- build.zig: extracted module factory to eliminate duplicated addCSourceFiles blocks
- build.zig: added build.zig.zon (required by zig 0.14+, minimum_zig_version = "0.14.0")
- src/main.zig: added top-level `test {}` block to pull in all module tests
- src/main.zig: silenced unused import warnings with `_ = worker` etc.
- src/worker.zig: removed unused `stats` import; fixed bool discard with `_ =`
- src/stratum.zig: replaced multiline raw string JSON literals with
  explicit escaped strings (avoids zig 0.16 parser edge cases)
- src/stratum.zig: removed unused `allocator` param from `subscribe`
- WSL note: if building from /mnt/c/, run inside ~/YesZigR32 or pass
  `--cache-dir /tmp/yeszigr32-cache` to avoid NTFS rename AccessDenied

## [0.2.0] — 2026-06-28

- Vendored yescrypt C core from LuckyPepeChain/luckypepe-chain src/crypto/yescrypt/
  - ccore/yescrypt.c  (N=4096, r=32, pers="WaviBanana")
  - ccore/sha256.c, sha256.h, sysendian.h, insecure_memzero.c/.h
- ccore/yescrypt.h: trimmed to mining ABI (yescrypt_hash only)
- build.zig: compile both yescrypt.c and sha256.c; tests gate install
- src/job.zig: wired real yescrypt_hash; passwd=salt=header (PoW convention)
- DO NOT replace vendored core with openwall/yescrypt

## [0.1.0] — 2026-06-28

- Initial project skeleton
