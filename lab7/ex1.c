#include <stdio.h>

int AA[100]; //Lineraized version of A[10][10]
int BB[100]; //Lineraized version of B[10][10]
int CC[100]; //Lineraized version of C[10][10]
int m;       //Actual size of the above matricies is mxm, where m is at most 10


void empty()
{
	int i = 0;
	for(i = 0; i < 100; i++)
	{
		AA[i] = 0;
		BB[i] = 0;
		CC[i] = 0;
	}
}

void print(int max, int m)
{
	int i, cnt = 0;
	for(i = 0; i < max; i++)
	{
		if(cnt < m)
		{
			printf("%d ", CC[i]);
			cnt += 1;
		}
		
		if(cnt == m)
		{
			printf("\n");
			cnt = 0;
		}
		
	}
}

void matmult(int m)
{
	int i , j, k, sum = 0;
	for(i = 0; i < m; i++)
	{
		for(j = 0; j < m; j++)
		{
			sum = 0;
			for(k = 0; k < m; k++)
			{
				sum = sum + AA[i * m + k] * BB[k * m + j];
				CC[i * m + j] = sum;
			}
		}
	}
}

int main()
{
	
	//Filling the matrixes
	scanf("%d", &m);
	empty();
	
	int i, max = m * m;
	
	for(i = 0; i < max; i++)
	{
		scanf("%d", &AA[i]);
	}
	for(i = 0; i < max; i++)
	{
		scanf("%d", &BB[i]);
	}
	
	//Do the multiplication
	matmult(m);
	
	//Printing the matrix
	print(max, m);
	
}