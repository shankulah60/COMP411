/* Example: analysis of text */

#include <stdio.h>
#include <string.h>

#define MAX 1000 /* The maximum number of characters in a line of input */

int main()
{
  char text[MAX], c, flipped[MAX];
  int i, cnt;
  int lowercase, uppercase, digits, other;
  int length;
  
  puts("Type some text (then ENTER):");
  
  /* Save typed characters in text[]: */
    
//Calculate a length from an input using fgets
  fgets(text, MAX, stdin);
  for( i  = 0; i < strlen(text); i++)
  {
	  if(text[i] == '\n')
	  {
		  text[i] = '\0'; //Null character, terminates string
	  }
	  
  }
  
  length = strlen(text);
   
  cnt = length - 1;
  for( i = 0; i < length; i++)
  {
	  flipped[i] = text[cnt];
	  cnt = cnt - 1;
  }
  
  flipped[length] = '\0';
  
  printf("Your input in reverse is:\n");
  printf("%s\n", flipped);
  
  int pal = 1;
  for(i = 0; i < length; i++)
  { 
	  if(flipped[i] != text[i])
	  {
		  pal = 0;
		  break;
	  }
  }
  
  if(pal == 1)
  {
	  printf("Found a palindrome!");
  }
  
}