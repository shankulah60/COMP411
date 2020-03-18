#include <stdio.h>
#include <stdlib.h>

char buffer[256];

int check()
{
	int i = 0;
	int operator = 0;
	for(i = 0; i < 256; i++)
	{
		char t = buffer[i];
		if(t == '+' || t == '-' || t =='*' || t == '/')
		{
			operator = 1;
			break;
		}
	}
	return operator;
}

void printer()
{
	int i = 0;
	for(i = 0; i < 256; i++)
	{
		if(buffer[i] == ' ')
		{
			buffer[i] = '_';
		}
		printf("%c ", buffer[i]);
	}
}

void clean()
{
	int i = 0;
	for(i = 0; i < 256; i++)
	{
		buffer[i] = ' ';
	}
}

int main()
{
	
	int i = 0;
	int check_val = 0;
	for(i = 0; i < 3; i++)
	{
		fgets(buffer, 256, stdin);
		check_val = check();
		if(check_val == 0)
		{
			exit(0);
		}
		//printer();
		//printf("<%s>\n",buffer);
		printf("\n");
		clean();
	}
}