# YesZigR32 Changelog

## [0.2.0] — 2026-06-28

- Vendored yescrypt C core from LuckyPepeChain/luckypepe-chain src/crypto/yescrypt/
  - ccore/yescrypt.c  (N=4096, r=32, pers="WaviBanana")
  - ccore/sha256.c
  - ccore/sha256.h
  - ccore/sysendian.h
  - ccore/insecure_memzero.c / .h
- ccore/yescrypt.h: trimmed to mining ABI (yescrypt_hash only)
- build.zig: updated to compile both yescrypt.c and sha256.c
- src/job.zig: wired real yescrypt_hash; passwd=salt=header (PoW convention)
- Added hashHeader smoke test: verifies non-zero output on zero input
- DO NOT replace vendored core with openwall/yescrypt

## [0.1.0] — 2026-06-28

- Initial project skeleton
- build.zig: Zig + C dual compilation wired
- ccore/yescrypt.h + ccore/yescrypt.c: C ABI boundary (stub)
- src/main.zig: entry point + Config struct
- src/stratum.zig: Stratum V1 client shell
- src/job.zig: hashHeader + meetsDifficulty
- src/worker.zig: per-thread nonce loop
- src/stats.zig: hashrate + share counters

### Remaining
- [ ] Wire stratum client into main
- [ ] Wire worker threads into main
- [ ] VarDiff support
- [ ] Non-blocking share submit
- [ ] CPU affinity / thread pinning
- [ ] CLI argument parsing
