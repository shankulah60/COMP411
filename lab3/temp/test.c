
#include <stdio.h>

int main()
{
	
	char text[100], flipped[100];
	
	fgets(text, 100, "mom");
	int i, cnt;
	cnt = 0;
	for(i = strlen(text) - 1; i > 0; i--)
	{
		flipped[cnt] = text[i - 1];
		cnt += 1;
	}
	printf("%s\n", text);
	printf("%s\n", flipped);
	printf("%d\n", strcmp(text, flipped));
	
}