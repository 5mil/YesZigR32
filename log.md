# YesZigR32 Changelog

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
- [ ] Vendor Openwall yescrypt optimized core into ccore/
- [ ] Wire stratum client into main
- [ ] Wire worker threads into main
- [ ] VarDiff support
- [ ] Non-blocking share submit
- [ ] CPU affinity / thread pinning
- [ ] CLI argument parsing
