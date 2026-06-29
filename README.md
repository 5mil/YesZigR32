# YesZigR32

A focused, single-algorithm CPU miner for **YescryptR32** — Zig outer layer, C hash core, zero multi-algo baggage.

## Architecture

```
src/
  main.zig          — entry point, thread spawning, config
  stratum.zig       — stratum V1 TCP client
  job.zig           — job parsing, nonce iteration, share check
  worker.zig        — per-thread mining loop
  stats.zig         — hashrate, accepted/rejected counters
ccore/
  yescrypt.c        — vendored Openwall yescrypt optimized core
  yescrypt.h        — C header for ABI boundary
build.zig           — Zig build script (compiles C core + Zig)
```

## Design Goals

- One algorithm, one code path
- C ABI boundary at the hash layer only
- No heap allocation in the hot hash loop
- Non-blocking share submission
- CPU affinity + thread pinning support

## Build

```bash
zig build
./zig-out/bin/yeszigr32 --host pool.example.com --port 3032 --user wallet.worker
```

## Status

- [ ] yescrypt C core integration
- [ ] Stratum V1 client
- [ ] Job engine + nonce loop
- [ ] Worker threads + affinity
- [ ] Stats + hashrate display
- [ ] VarDiff support
- [ ] Share submit non-blocking

## License

MIT
