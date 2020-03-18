#include <stdio.h>


void linePrinter(int w, char end, char fill)
{
	
	int i = w - 2;
	printf("%c", end);
	if(w > 1)
	{
		for(i; i > 0; i--)
		{
		printf("%c", fill);
		}
		printf("%c", end);
	}
	printf("\n");
	fflush(stdin);
}

int main()
{
	int width = 0, height = 0;
	
	while(1)		//Always runs
	{
		fflush(stdin);
		printf("Please enter width and height:\n");
		scanf("%d", &width);
		if(width == 0)
		{
			printf("End\n");
			break;
		}
		else
		{
			scanf("%d", &height);
			//Printing the rectangle
			linePrinter(width, '+', '-'); //Prints the top of the rectangle
			if(height > 1)
			{
				int i  = height - 2;
				for(i; i > 0; i--)
				{
					linePrinter(width, '|', '~'); //Prints the sides and interior
				}
				linePrinter(width, '+', '-'); //Prints the bottom of the rectangle
			}
			
		}
	}
}