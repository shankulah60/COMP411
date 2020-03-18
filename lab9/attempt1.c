#include <stdio.h>

void allBinary(int len)
{
	int i, j;
	//Looping for all possible combinations
	for(i = 0; i < (1 << len); i++)
	{
		
		for(j = len - 1; j >= 0; j--)
		{
			printf("%d", ((1 << j) & i) > 0);
		}
		printf("\n");
	}
}

int main()
{
	int n;
	scanf("%d", &n);
	allBinary(n);
}