/*
 * Vendored from LuckyPepeChain/luckypepe-chain src/crypto/yescrypt/insecure_memzero.h
 */
#ifndef _INSECURE_MEMZERO_H_
#define _INSECURE_MEMZERO_H_
#include <stddef.h>
static void insecure_memzero(volatile void *, size_t);
#include "insecure_memzero.c"
#endif
