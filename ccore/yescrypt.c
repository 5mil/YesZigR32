/**
 * yescrypt.c — YescryptR32 C core for YesZigR32
 *
 * This is the ABI boundary between the Zig miner and the yescrypt
 * algorithm. Replace the stub below with the Openwall optimized
 * yescrypt implementation (openwall/yescrypt on GitHub).
 *
 * Parameters for YescryptR32:
 *   N = 2048, r = 32, p = 1, flags = YESCRYPT_RW, t = 0, g = 0
 */

#include "yescrypt.h"
#include <string.h>

/*
 * STUB: placeholder until Openwall yescrypt source is vendored in.
 * Replace this with yescrypt-best.c from openwall/yescrypt.
 */
void yescrypt_hash(const uint8_t *input, size_t inputlen, uint8_t *output) {
    (void)input;
    (void)inputlen;
    /* Zero output — replace with real yescrypt call */
    memset(output, 0, 32);
}
