/*
 * Copyright(C), 2016, Simon.
 * File name     : base64.h
 * Author        : Simon
 * E-Mail        : xue.shumeng@yahoo.com
 * Version       : 0.1.0
 * Date          : Thu Apr 21 16:41:52 2016
 * Description   : 简单Base64编码、解码头文件
 * Function List : None
 * History       : None
 */

#ifndef BASE
#define BASE

/* 函数声明 */
void encode(const char *input, char *output);
void decode(const char *input, char *output);

#endif
