//Exercise 1

#include<stdio.h>

int main()
{
	int num = 0;
	printf("Enter a number from 1 to 20:\n");
	scanf("%d", &num);
	if(num > 0 && num < 21)  //In range
	{
		int i = 1;
		printf("Here are the first %d ordinal numbers:\n", num);
		for(i = 1; i <= num; i++)
		{
			if(i == 1)
			{
				printf("%dst\n", i);
			}
			else if( i == 2)
			{
				printf("%dnd\n", i);
			}
			else if( i ==3)
			{
				printf("%drd\n", i);
			}
			else
			{
				printf("%dth\n", i);
			}
		}
	}
	else
	{
		printf("Number is not in the range from 1 to 20\n");
	}	
}