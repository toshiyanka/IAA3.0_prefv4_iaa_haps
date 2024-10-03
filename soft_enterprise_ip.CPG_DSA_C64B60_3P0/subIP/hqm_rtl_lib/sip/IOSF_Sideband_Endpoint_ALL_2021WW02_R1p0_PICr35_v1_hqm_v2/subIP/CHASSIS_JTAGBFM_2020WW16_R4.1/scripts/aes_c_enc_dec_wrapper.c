#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <openssl/aes.h>

//---------------------------------------------------------------------------------------
// Author: svbandan
// Date: 22-Sep-16
// Purpose: 1504332996: [JTAG BFM] [enDebug] Capability in the JTAG BFM itself to support enDebug encryption/decryption
// HSD URL: https://hsdes.intel.com/resource/1504332996
// http://stackoverflow.com/questions/11184882/openssl-aes-set-encrypt-key-differing-depending-on-compilation-target
//---------------------------------------------------------------------------------------
 
/* AES key for Encryption and Decryption */
 
/* Print Encrypted and Decrypted data packets */
void print_data(const char *tittle, const void* data, int len);
unsigned char iv[AES_BLOCK_SIZE];
AES_KEY enc_key,dec_key;
 
void aes_c_enc_wrapper(const unsigned char* original_data, const unsigned char* aes_enc_key, unsigned char* aes_enc_out){
	
   const unsigned long data_length = 16;
   const unsigned long key_length = 32;
	/* Init vector */
	memset(iv, 0x00, AES_BLOCK_SIZE);
	/* AES-128 bit CBC Encryption */
	AES_set_encrypt_key(aes_enc_key, key_length*8, &enc_key);
	AES_cbc_encrypt(original_data, aes_enc_out,data_length , &enc_key, iv, AES_ENCRYPT);
	print_data("\n ENC : Original ",original_data, data_length); // you can not print data as a string, because after Encryption its not ASCII
	print_data("\n ENC : Encrypted",aes_enc_out, data_length);
	
	print_data("\n ENC : Key",aes_enc_key, key_length);
	
	
}

void aes_c_dec_wrapper(const unsigned char* aes_enc_in, const unsigned char* aes_dec_key, unsigned char* aes_dec_out){
	
	/* Init vector */
   const unsigned long data_length = 16;
   const unsigned long key_length = 32;
	memset(iv, 0x00, AES_BLOCK_SIZE);
	
	/* AES-128 bit CBC Decryption */
	AES_set_decrypt_key(aes_dec_key, key_length*8, &dec_key); // Size of key is in bits
	AES_cbc_encrypt(aes_enc_in, aes_dec_out, data_length, &dec_key, iv, AES_DECRYPT);
	print_data("\n DEC : Encrypted",aes_enc_in, data_length);
	
	print_data("\n DEC : Decrypted",aes_dec_out, data_length);
	print_data("\n DEC : Key",aes_dec_key, key_length);
	
}
#ifdef C_ONLY 
int main( )
{
	unsigned char aes_input_1[]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
   unsigned char aes_key_1[]={0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x99,0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,0x00,0xFF,0xEE,0xDD,0xCC,0xBB,0xAA,0x99,0x88,0x77,0x66,0x55,0x44,0x33,0x22,0x11,0x00};
	
	/* Buffers for Encryption and Decryption */
	unsigned char enc_out_1[sizeof(aes_input_1)];
	unsigned char dec_out_1[sizeof(aes_input_1)];
   aes_c_enc_wrapper(aes_input_1, aes_key_1,enc_out_1);
   aes_c_dec_wrapper(enc_out_1, aes_key_1, dec_out_1);
	/* Printing and Verifying */
	print_data("\n Original ",aes_input_1, sizeof(aes_input_1)); // you can not print data as a string, because after Encryption its not ASCII
	
	print_data("\n Encrypted",enc_out_1, sizeof(enc_out_1));
	
	print_data("\n Decrypted",dec_out_1, sizeof(dec_out_1));
	
}
#endif
 
void print_data(const char *tittle, const void* data, int len)
{
	printf("%s : ",tittle);
	const unsigned char * p = (const unsigned char*)data;
	int i = 0;
	
	for (; i<len; ++i) {
		printf("%02X ", *p++);
	}
	printf("\n");
}
