#include <stdio.h>

int A[10][10];
int B[10][10];
int D[10][10];
int size;

void empty()
{
	int i, j;
	for(i = 0; i< 10; i++)
	{
		for(j = 0; j < 10; j++)
		{
			A[i][j] = ' ';
			B[i][j] = ' ';
			D[i][j] = ' ';
		}
	}
}

void matrixMultiply(int a[10][10], int b[10][10]) 
{
   static int sum, i = 0, j = 0, k = 0;
   //row of first matrix
   if (i < size) 
   {
      //column of second matrix
      if (j < size) 
	  {
         if (k < size) 
		 {
            sum = sum + a[i][k] * b[k][j];
            k++;
            matrixMultiply(a, b);
         }
         D[i][j] = sum;
         sum = 0;
         k = 0;
         j++;
         matrixMultiply(a, b);
      }
      j = 0;
      i++;
      matrixMultiply(a, b);
   }
}

int main()
{
	int i, j, k;
	scanf("%d", &size);
	empty();
	
	//Filling array A
	for(i = 0; i < size; i++)
	{
		for(j = 0; j < size; j++)
		{
		  	scanf("%d", &A[i][j]);
		}
	}
	//Filling array B
	for(i = 0; i < size; i++)
	{
		for(j = 0; j < size; j++)
		{
			scanf("%d", &B[i][j]);
		}
	}
	
	matrixMultiply(A, B);

    for (i = 0; i < size; i++) 
	{
		for (j = 0; j < size; j++) 
		{
			printf("%6d", D[i][j]);
		}
		printf("\n");
    }
	  
}