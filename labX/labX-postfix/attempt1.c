#include <stdio.h>
#include <ctype.h>

int main()
{
	
	char inLine [64];
	int nums[32];
	char operations[32];
	fgets(inLine, 64, stdin);
	int i = 0;
	int num_cnt = 0;
	int op_cnt = 0;
	for( i = 0; i < 64; i++)
	{
		if(inLine[i] == '0')
		{
			//Exit the program
		}
		if(isdigit(inLine[i]))
		{
			nums[num_cnt] = inLine[i];
			num_cnt += 1;
		}
		if(isoperation(inLine[c])
		{
			operations[op_cnt] = inLine[i];
			op_cnt += 1;
		}
	}
	printf("%s", inLine);
	
}

isoperation(char c)
{
	if(c == '+' || c == '-' || c == '/' || c == '*')
	{
		return true;
	}
}