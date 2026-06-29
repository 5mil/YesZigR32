/*
 * Vendored from LuckyPepeChain/luckypepe-chain src/crypto/yescrypt/insecure_memzero.c
 */
#include <stddef.h>
#ifndef _INSECURE_MEMZERO_H_
static
#endif
void insecure_memzero(volatile void * buf, size_t len)
{
	volatile uint8_t * _buf = (volatile uint8_t *)buf;
	while (len) { *_buf++ = 0; len--; }
}
