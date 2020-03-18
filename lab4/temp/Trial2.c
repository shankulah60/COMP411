/* Example: bubble sort strings in array */

#include <stdio.h>  /* Need for standard I/O functions */
#include <string.h>

#define NUM 25   /* number of strings */
#define LEN 1000  /* max length of each string */

void my_swap_strings(char string1[], char string2[]) {
  char temp;    // char variable used in swapping one character at a time

  /* Write code here to swap the contents of string1 and string2, one
     character at a time, WITHOUT USING ANY C STRING LIBRARY FUNCTIONS. 

     The max length of the strings is LEN, though they may be shorter, so look
     for the string terminators.
  */
  int i  = 0;
  for(i = 0; (string1[i] != '\0' || string2[i] != '\0'); i++)
  {
	  temp = string1[i];
	  string1[i] = string2[i];
	  string2[i] = temp;
  }
}

int main()
{
  char newLineStrings[NUM][LEN];
  char Strings[NUM][LEN];
  char temp [LEN];

  printf("Please enter %d strings, one per line:\n", NUM);

  /* Write a for loop here to read NUM strings.

     Use fgets(), with LEN as an argument to ensure that an input line that is too
     long does not exceed the bounds imposed by the string's length.  Note that the
     newline and NULL characters will be included in LEN.
  */

  int i;
  int j = 0;
  for(i = 0; i <= NUM; i++)
  {
	  fgets(newLineStrings[i], LEN, stdin);
	  int len = strlen(newLineStrings[i]);
	  newLineStrings[i][len - 1] = '\0';
	  if(newLineStrings[i][0] == '\n' || len == 0 || newLineStrings[i] == "")
	  {
		  continue;
	  }
	  else
	  {
		  strcpy(Strings[i], newLineStrings[i]);
		  j += 1;
	  }
  }
  
  
  puts("\nHere are the strings in the order you entered:");

  /* Write a for loop here to print all the strings. */
	
	for( i = 0; i <= NUM; i++)
	{
		puts(Strings[i]);
	}
  
  /* Bubble sort */
  /* Write code here to bubble sort the strings in ascending alphabetical order

     Use the function my_compare_strings() to compare two strings.  If they are out of order,
     use the function my_swap_strings() to swap their contents.

  */
   for(i = 0; i <= NUM; i++)
   {
	   for(j = i + 1; j <= NUM; j++)
	   {
		   if(strcmp(Strings[i], Strings[j]) > 0)
		   {
				//my_swap_strings(Strings[i], Strings[j]);
				strcpy(temp, Strings[i]);
				Strings[i][0] = '\0';
				strcpy(Strings[i], Strings[j]);
				Strings[j][0] = '\0';
				strcpy(Strings[j], temp);
				temp[0] = '\0';
				//printf("String i: %s \n String j: %s\n", Strings[i], Strings[j]);
		   }
	   }
   }
  
  
  /* Output sorted list */
  
  puts("\nIn alphabetical order, the strings are:");     
  /* Write a for loop here to print all the strings. Feel free to use puts/printf
     etc. for printing each string.
  */
  for( i = 0; i <= NUM; i++)
  {
	  puts(Strings[i]);
  }
}