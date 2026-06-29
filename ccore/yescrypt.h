#ifndef YESCRYPT_H
#define YESCRYPT_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * yescrypt_hash - YescryptR32 hash for proof-of-work mining.
 * @input:  pointer to block header bytes
 * @inputlen: length of input (typically 80 bytes)
 * @output: pointer to 32-byte output buffer
 */
void yescrypt_hash(const uint8_t *input, size_t inputlen, uint8_t *output);

#ifdef __cplusplus
}
#endif

#endif /* YESCRYPT_H */
