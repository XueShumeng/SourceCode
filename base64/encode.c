#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "base64.h"

int main(int argc, char *argv[])
{
  if(argc == 1)
    {
      fprintf(stderr,"%s\n","Input Error");
      exit(1);
    }
  char *uncode = argv[1];
  char *encoded;
  encoded = malloc(strlen(uncode) * 4 / 3);
  memset(encoded,'0',strlen(uncode) * 4 / 3);
  encode(uncode,encoded);
  fprintf(stdout,"%s\n",encoded);
  exit(0);
}
