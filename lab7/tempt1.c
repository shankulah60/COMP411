#include<stdio.h>



int main()
{
	int i[4];
	int j[4];
	int k[4];

	int p = 0, x = 0, y = 0, z = 0;
	
	for(p = 0; p < 4; p++)
	{
		scanf("%d\n", &i[p]);
	}
	
	for(p = 0; p < 4; p++)
	{
		scanf("%d\n", &j[p]);
	}
	
	for (x = 0; x < 2; x++) 
	{ 
		// row number of output
		for (y = 0; y < 2; y++) 
		{ 
			// column number of output
			k[2*x+y] = 0;
			for (z = 0; z < 2; z++) 
			{ 
				// four elements are added for this output
				k[2*x+y] += i[2*x+z] * j[2*z+y];
			}
		}
	}
	
	//printing the result
	for(p = 0; p < 2; p++)
	{
		printf("%6d", k[p]);
		printf("      ");
	}
	
	printf("\n");
	
	for(p = 2; p < 4; p++)
	{
		printf("%6d", k[p]);
		printf("      ");
	}
	
	
}
