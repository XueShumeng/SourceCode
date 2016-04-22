/*
 * Copyright(C), 2016, Simon.
 * File name     : base64.c
 * Author        : Simon
 * E-Mail        : xue.shumeng@yahoo.com
 * Version       : 0.1.0
 * Date          : Wed Apr 13 08:38:35 2016
 * Description   : 简单实现Base64加解密
 * Function List : encode/3
 * History       : None
 */
#include <string.h>
#include "base64.h"

/* Base64 编码字符集 */
char enchar[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

/* Base64 解码字符集 */
int de[256] =  {
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 0   - 15
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 16  - 31
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, // 32  - 47
  52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, // 48  - 63
  -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, // 64  - 79
  15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, // 80  - 95
  -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, // 96  - 111
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1, // 112 - 127
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 128 - 143
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 144 - 159
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 160 - 175
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 176 - 191
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 192 - 207
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 208 - 223
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 224 - 239
  -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, // 240 - 255
};


/*
 * Function    : encode
 * Description : 简单实现Base编码
 * Calls       : None
 * Called By   : main
 * Input       : const char *input :: 被编码字符
 *               const size_t length :: 被编码字符长度
 *               char *output :: 输出指针
 * Output      : char *outpt :: 输出已编码的字符指针
 * Return      : void
 * Others      : None
 */
void encode(const char *input, char *output)
{
  *output = '\0';
  size_t len = strlen(input);
  if(input == NULL || len <= 0)
    return;
  char *in = (char *)input; /* 输入字符 */
  char *out = (char *)output; /* 输出字符 */
  char *end = (char *)input + len; /* 结束地址 */

  /*
   * 掩码
   * 0x30 0011 0000
   * 0x3c 0011 1100
   * 0x3f 0011 1111
   */
  while(end - in >= 3)
    {
      /* 每次处理三个字节 */
      *out++ = enchar[(in[0] >> 2)];
      *out++ = enchar[(in[0] << 4 & 0x30) | (in[1] >> 4)];
      *out++ = enchar[(in[1] << 2 & 0x3c) | (in[2] >> 6)];
      *out++ = enchar[in[2] & 0x3f];
      in += 3;
    }
  /* 不足3个字节时 */
  if(end - in > 0)
    {
      *out++ = enchar[(in[0] >> 2)];
      if(end - in == 2)
        {
          *out++ = enchar[(in[0] << 4 & 0x30) | (in[1] >> 4)];
          *out++ = enchar[(in[1] << 2) & 0x3c];
          *out++ = '=';
        }else if(end - in == 1)
        {
          *out++ = enchar[(in[0] << 4) & 0x30];
          *out++ = '=';
          *out++ = '=';
        }
    }
}

void decode(const char *input, char *output)
{
  if(input == NULL || output == NULL)
    return;
  size_t len = strlen(input);
  if(len < 4 || len % 4 != 0)
    return;
  char *in = (char *)input;
  char *out = (char *)output;
  char *end = (char *)input + len;
  /*
   * 掩码
   * 0xFC 1111 1100
   */
  for(;in < end; in += 4)
    {
      *out++ = ((de[in[0]] << 2) & 0xFC) | ((de[in[1]] >> 4) & 0x03);
      *out++ = ((de[in[1]] << 4) & 0xF0) | ((de[in[2]] >> 2) & 0x0F);
      *out++ = ((de[in[2]] << 6) & 0xC0) | de[in[3]];
    }
  if(*(end - 2) == '=')
    {
      *(out - 2) = '\0';
    }
  else if(*(end - 1) == '=')
    {
      *(out - 1) = '\0';
    }
}
