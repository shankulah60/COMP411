#include <stdio.h>

void printArr(int n, int arr[])
{
	int i;
	for(i = 0; i < n; i++)
	{
		printf("%d", arr[i]);
	}
	printf("\n");
}

void binary(int n, int arr[], int i)
{
	if(i == n)
	{
		printArr(n, arr);
		return;
	}
	else
	{
		arr[i] = 0;
		binary(n, arr, i + 1);
		
		arr[i] = 1;
		binary(n, arr, i + 1);
	}
}

int main()
{
	int n;
	scanf("%d", &n);
	int arr[n];
	binary(n, arr, 0);

}

