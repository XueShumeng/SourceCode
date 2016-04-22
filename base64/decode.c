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

  char *input = argv[1];
  char *decoded;
  size_t len = strlen(input);
  decoded = malloc(len * 4 / 3);
  memset(decoded,'0',len * 4 / 3);
  decode(input,decoded);
  fprintf(stdout,"%s\n",decoded);
  exit(0);
}
