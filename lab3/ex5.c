#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#define MAX_BUF 1024

int main () {

  char buf[MAX_BUF];
  int length;
  int i, newln = 0;
  // other stuff

  do {
        // read a line
		fgets(buf, MAX_BUF, stdin);
		//Removing the last characters
		
		//buf[strlen(buf) - 1] = '\0';
        // calculate its length
		length = strlen(buf) - 1;
        // modify the line by switching characters
		
		for( i = 0; i < length; i++)
		{
			if(tolower(buf[i]) == 'e')
			{
				buf[i] = '3';
			}
			
			if(tolower(buf[i]) == 'i')
			{
				buf[i] = '1';
			}
			
			if(tolower(buf[i]) == 'o')
			{
				buf[i] = '0';
			}
			
			if(tolower(buf[i]) == 's')
			{
				buf[i] = '5';
			}
		}
		
		if(buf[0] == '\n')
		{
			break;
		}
		else
		{
			printf("%s", buf);
		}
	

		
        // print the modified line
		//buf[length] = '\0';

  } while (length > 1);
}