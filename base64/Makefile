# Copyright(C), 2016, Simon.
# File name     : Makefile
# Author        : Simon
# E-Mail        : xue.shumeng@yahoo.com
# Version       : 0.1.0
# Date          : Fri Apr 22 07:41:43 2016
# Description   : 编译Base
# Function List : None
# History       : None

.PHONY : clean

CC := gcc

all: encode decode

encode: 
	$(CC) -o encode encode.c base64.c

decode:
	$(CC) -o decode decode.c base64.c

clean:
	rm -rf encode
	rm -rf decode

