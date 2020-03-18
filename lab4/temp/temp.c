#include<stdio.h>
#include<string.h>

int my_compare_strings(char Str1[], char Str2[]);
int my_swap_strings(char str1[], char str2[]);

int main(){
   int i,j,count;
   char str[25][25],temp[25];
   puts("How many strings u are going to enter?: ");
   scanf("%d",&count);

   puts("Enter Strings one by one: ");
   for(i=0;i<=count;i++)
      gets(str[i]);
   for(i=0;i<=count;i++)
      for(j=i+1;j<=count;j++){
         if(my_compare_strings(str[i],str[j])>0){
            /*strcpy(temp,str[i]);
            strcpy(str[i],str[j]);
            strcpy(str[j],temp);*/
           my_swap_strings(str[i],str[j]); 
         }
      }
   printf("Order of Sorted Strings:");
   for(i=0;i<=count;i++)
      puts(str[i]);
}

int my_compare_strings(char Str1[], char Str2[])
{
	int i = 0;
  	while(Str1[i] == Str2[i])
  	{
  		if(Str1[i] == '\0' && Str2[i] == '\0')
	  		break;
		i++;
	}
	return Str1[i] - Str2[i];
}

int my_swap_strings(char str1[], char str2[])
{
char temp;
int i=0;

	for(i=0; str1[i]!='\0'|| str2[i]!='\0'; i++)
	{
		temp = str1[i];
		str1[i] = str2[i];
		str2[i] = temp;
	}
return 0;
}