#include <stdio.h>
#include <stdlib.h>
#define MAX 32

/*
Post fix notation turtorial video:
https://www.youtube.com/watch?v=L9xpyah1taw
-Good visualization of what the code needs to do (in terms of stacks)
*/

//Global Variables 
char buffer[MAX];
int stack[MAX];
int stack_size = 0;

//Function headers
void add_stack();
void mult_stack();
void div_stack();
void sub_stack();
int checker();
void cleaner();

int main()
{
	while(1)
	{
		cleaner();  //Get rid of residual values
		fgets(buffer, 31, stdin);
		//Setting default values
		if(checker() == 0)
		{
			//Found the termination key, terminate the program
			exit(0);
		}
		int i = 0;
		int value = 0;
		int mult = 1;
		char a = '_';
		char b = '_';
		
		while(buffer[i] != '\0' && buffer[i] != '\n')
		{
			a = buffer[i]; //The first character
			b = buffer[i + 1]; //The next character
			i += 1; 	//Increment the buffer index
			//Check if the character is an operator
			if( a == '+')
			{
				//Call the addition function and continue to the next set of characters
				add_stack();
				continue;
			}
			else if( a == '*')
			{
				//Call the mult. function and continue to the next set of characters
				mult_stack();
				continue;
			}
			else if( a == '/')
			{
				//Can't handle negative numbers, checking the bounds
				//Cal the div. function and continue to the next set of characters
				div_stack();
				continue;
			}
			else if( a == '-' && (b <= '0' || b >= '9'))
			{
				//Call the sub. function and continue to the next set of characters
				sub_stack();
				continue;
			}
			else if( a == ' ')
			{
				//Not an operator, so get the next set of characters
				continue;
			}
			
			
			value = 0;
			mult = 1;
			
			while(a != ' ' && a != '\0' && a != '\n')
			{
				if( a  == '-')
				{
					mult -= 1;
				}
				if( a >= '0' && a <= '9')
				{
					value = (value * 10) + ( a - '0');
				}
				a = buffer[i];
				i += 1;
			}
			
			value = value * mult;
			stack[stack_size] = value;
			stack_size += 1;
		}
		printf("%d\n", stack[stack_size - 1]);
	}
}

//Addition function
void add_stack()
{
	int result = 0;
	result = stack[stack_size - 2] + stack[stack_size - 1];
	stack[stack_size - 2] = result;
	stack_size -= 1;
}

//Multiplication function
void mult_stack()
{
	int result = 0;
	result = stack[stack_size - 2] * stack[stack_size - 1];
	stack[stack_size - 2] = result;
	stack_size -= 1;
}

//Division function
void div_stack()
{
	int result = 0;
	result = stack[stack_size - 2] / stack[stack_size - 1];
	stack[stack_size - 2] = result;
	stack_size -= 1;
}

//Subtraction function
void sub_stack()
{
	int result = 0;
	result = stack[stack_size - 2] - stack[stack_size - 1];
	stack[stack_size - 2] = result;
	stack_size -= 1;
}

//Check the string
int checker()
{
	int i = 0;
	int operator = 0;
	for(i = 0; i < MAX; i++)
	{
		char t = buffer[i];
		if(t == '+' || t == '*' || t == '/' ||t == '-')
		{
			operator = 1;
			break;
		}
	}
	return operator;
}

void cleaner()
{
	int i = 0;
	for(i = 0; i < MAX; i++)
	{
		buffer[i] = ' ';
	}
}