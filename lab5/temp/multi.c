#include<stdio.h>
#define MAX 10
 
void matrixMultiply(int[MAX][MAX], int[MAX][MAX]);
int row1, row2, col1, col2;
int size;
int res[MAX][MAX];
int mat1[MAX][MAX], mat2[MAX][MAX];
 
int main() {
 
   int i, j, k;
 
   /*
   printf("Enter the row and column of first matrix: ");
   scanf("%d%d", &row1, &col1);
   printf("Enter the row and column of second matrix: ");
   scanf("%d%d", &row2, &col2);
   */
   
   scanf("%d", &size);
   //row2 = col1 = col2 = row1;
 
	/*
      printf("Enter the First matrix: ");
      for (i = 0; i < row1; i++) {
         for (j = 0; j < col1; j++) {
            scanf("%d", &mat1[i][j]);
         }
      }
 
      printf("Enter the Second matrix: ");
      for (i = 0; i < row2; i++) {
         for (j = 0; j < col2; j++) {
            scanf("%d", &mat2[i][j]);
         }
      }
	  
	*/
	
	  //Filling array A
	  for(i = 0; i < size; i++)
	  {
		  for(j = 0; j < size; j++)
		  {
		  	  scanf("%d", &mat1[i][j]);
		  }
	  }
	  //Filling array B
	  for(i = 0; i < size; i++)
	  {
		  for(j = 0; j < size; j++)
		  {
			  scanf("%d", &mat2[i][j]);
		  }
	  }
	
      printf("\nThe First matrix is: n");
      for (i = 0; i < size; i++) {
         printf("\n");
         for (j = 0; j < size; j++) {
            printf("%d ", mat1[i][j]);
         }
      }
 
      printf("\nThe Second matrix is: n");
      for (i = 0; i < size; i++) {
         printf("\n");
         for (j = 0; j < size; j++) {
            printf("%d ", mat2[i][j]);
         }
      }
      matrixMultiply(mat1, mat2);
 
   printf("\nThe multiplication of two matrixes is : \n");
   for (i = 0; i < size; i++) {
      printf("\n");
      for (j = 0; j < size; j++) {
         printf("%d ", res[i][j]);
      }
   }
   return 0;
}
 
void matrixMultiply(int a[MAX][MAX], int b[MAX][MAX]) {
   static int sum, i = 0, j = 0, k = 0;
   //row of first matrix
   if (i < size) {
      //column of second matrix
      if (j < size) {
         if (k < size) {
            sum = sum + a[i][k] * b[k][j];
            k++;
            matrixMultiply(a, b);
         }
         res[i][j] = sum;
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