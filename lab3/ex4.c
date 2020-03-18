#include <stdio.h>
#define MAX 3

int main()
{
	
	int A[MAX][MAX]; //matrix A
	int B[MAX][MAX]; //matrix B
	int C[MAX][MAX]; //matrix to store their sum
	
	int i, j;
	
	printf("Please enter 9 values for matrix A:\n");
	for( i = 0; i < MAX; i++)
	{
		scanf("%d%d%d", &A[i][0], &A[i][1], &A[i][2]);
	}		

	printf("Please enter 9 values for matrix B:\n");
	for( i = 0; i < MAX; i++)
	{
		scanf("%d%d%d", &B[i][0], &B[i][1], &B[i][2]);
	}	
		
	//Adding
	for(i = 0; i < MAX; i++)
	{
		for(j = 0; j < MAX; j++)
		{
			C[i][j] = A[i][j] + B[i][j];
		}
	}
	
	printf("C = B + A =\n");
	for(i = 0; i < MAX; i++)
	{
		printf("%10d%10d%10d\n", C[i][0], C[i][1], C[i][2]);
	}
}