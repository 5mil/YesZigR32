/*
 * yescrypt.h — ABI header for YesZigR32 C core
 *
 * Vendored from LuckyPepeChain/luckypepe-chain src/crypto/yescrypt/yescrypt.h
 * (trimmed to mining-relevant declarations only)
 */

#ifndef YESCRYPT_H
#define YESCRYPT_H

#include <stdint.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/**
 * yescrypt_hash - YescryptR32 PoW hash.
 *
 * passwd:    block header bytes (typically 80)
 * passwdlen: length of passwd
 * salt:      salt bytes (set to passwd for PoW)
 * saltlen:   length of salt
 * buf:       32-byte output buffer
 * buflen:    must be 32
 *
 * Returns 0 on success, -1 on allocation failure.
 * Parameters N=4096, r=32 are hardcoded. Personalisation="WaviBanana".
 */
int yescrypt_hash(const uint8_t *passwd, size_t passwdlen,
    const uint8_t *salt, size_t saltlen,
    uint8_t *buf, size_t buflen);

#ifdef __cplusplus
}
#endif

#endif /* YESCRYPT_H */
