//Example 2

#include <stdio.h>
#include <math.h>

double maximum(double nums[])
{
	int i = 0;
	double max = nums[0];
	for(i; i < 10; i++)
	{
		if(nums[i] > max)
		{
			max = nums[i];
		}
	}
	return max;
}

double minimum(double nums[])
{
	int i = 0;
	double min = nums[0];
	for(i; i < 10; i++)
	{
		if(nums[i] < min)
		{
			min = nums[i];
		}
	}
	return min;
}

double add(double nums[])
{
	double sum = 0.00;
	int i = 0;
	for(i; i < 10; i++)
	{
		sum += nums[i];
	}
	return sum;
}

double productNum(double nums[])
{
	double prod = 1.00;
	int i = 0;
	for(i; i < 10; i++)
	{
		prod = prod * nums[i];
	}
	return prod;
}

int main()
{
	double a,b,c,d,e,f,g,h,i,j;
	printf("Enter 10 floating-point numbers:\n");
	scanf("%lf %lf %lf %lf %lf %lf %lf %lf %lf %lf", &a,&b,&c,&d,&e,&f,&g,&h,&i,&j);
	double values[10] = {a,b,c,d,e,f,g,h,i,j};
	double sum = 0.00, product = 0.00, max = 0.00, min = 0.00;
	printf("Sum is %.5lf\n", add(values));
	printf("Min is %.5lf\n", minimum(values));
	printf("Max is %.5lf\n", maximum(values));
	printf("Product is %.5lf\n", productNum(values));
	
}