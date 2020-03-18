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

void print(int max)
{
	int i;
	for(i = 0; i < max; i++)
	{
		printf("%6d", CC[i]);
		printf("%6d", CC[i + 1]);
		printf("\n");
		i += 1;
	}
}

void matmult(int m)
{
	int row = 0, col = 0, i = 0;
	for(row = 0; row < m; row++)
	{
		for(col = 0; col < m; col++)
		{
			for(i = 0; i < m; i++)
			{
				CC[2 * row + col] += AA[2 * row + i] * BB[2 * i + col];
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
	print(max);
	
	
}