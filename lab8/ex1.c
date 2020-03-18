#include <stdio.h>

int NchooseK(int n , int k)
{
	if(n > -1 && k > -1)
	{
		if(k == 0)
		{
			return 1;
		}
		else if(k == n)
		{
			return 1;
		}
		else
		{
			return (NchooseK(n-1, k-1) + NchooseK(n-1, k));
		}
	}
}

int main()
{
	int n, k, val;
	//Input
	do
	{
		//printf("Enter two integers (for n and k) separated by space:\n");
		scanf("%d", &n);
		if(n == 0)
		{
			break;
		}
		scanf("%d", &k);
		val = NchooseK(n,k);
		printf("%d\n", val);
	}
	while(n > 0);
	
}