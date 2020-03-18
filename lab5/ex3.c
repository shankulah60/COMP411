#include <stdio.h>
#include <string.h>
#include <ctype.h>

char animals[20][60];
char lyrics[20][60];
int number;

void nurseryrhyme(int current)
{
	//Spacing Loop
	int i;
	for(i = 0; i < current/2; i++)
	{
		printf(" ");
	}
	
	//Swallowed Lines
	if(current < number - 2)
	{
		if(current == 0)
		{
			printf("There was an old lady who swallowed a %s;\n", animals[current]);
		}
		else
		{
			printf("She swallowed the %s to catch the %s;\n", animals[current - 2], animals[current]);
		}
	}
	
	//Recursive Call
	if(current + 2 < number - 1)
	{
		nurseryrhyme(current + 2);
	}
	
	//Spacing Loop
	//for(i = 0; i < current - 1; i++)
	for(i = 0; i < current/2; i++)
	{
		printf(" ");
	}
	
	//Don't Know Lines
	printf("I don't know why she swallowed a %s - %s\n", animals[current], animals[current + 1]);
	
}

int main()
{
	int i = 0;
	
	while(1)
	{
		//Getting the input
		fgets(animals[i], 60, stdin);
		//Adding the terminating character
		animals[i][strlen(animals[i]) - 1] = '\0';
		
		if(strcmp(animals[i], "END") == 0)
		{
			break;
		}
		i += 1;
	}
	
	number = i + 1;
	
	nurseryrhyme(0);
	
}