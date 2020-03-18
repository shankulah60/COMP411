#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>



int number;
typedef struct {
      int year;
      int month;
      int day;
      int ID;
    } record;

void accept(record list[], int s);
void display(record list[], int s);
void bsortdata( record list[], int s);

int main()
{

	record data[20];	
	
    int n;

    //printf("Number of records you want to enter? : ");
    scanf("%d", &n);

    accept(data, n);
    //printf("\nBefore sorting");
    //display(data, n);
    bsortdata(data, n);
    //printf("\nAfter sorting by year");
	
    display(data, n);
    return 0;

}

void accept(record list[20], int s)
{
    int i;
    for (i = 0; i < s; i++)
    {
        //printf("\n\nEnter data for Record #%d", i + 1);
        
        //printf("\nEnter year : ");
        scanf("%d", &list[i].year);

         //printf("\nEnter month : ");
        scanf("%d", &list[i].month);
		
		 //printf("\nEnter day : ");
        scanf("%d", &list[i].day); 
		
		   //printf("\nEnter ID : ");
        scanf("%d", &list[i].ID);
			
        
    } 
}

void display(record list[80], int s)
{
    int i;
    
    //printf("\n\nYear\tMonth\tDay\tID\n");
    for (i = 0; i < s; i++)
    {
        printf("%d %d %d %d\n", list[i].year, list[i].month, list[i].day, list[i].ID );
		fflush(stdout);
	
    } 
}

void bsortdata(record list[80], int s)
{
    int i, j;
    record temp;
    
    for (i = 0; i < s - 1; i++)
    {
        for (j = 0; j < (s - 1-i); j++)
        {
            //if (concatdate(list[j]) < concatdate(list[j + 1]))
			if (list[j].year > list[j + 1].year)	
            {
                temp = list[j];
                list[j] = list[j + 1];
                list[j + 1] = temp;
            } 
			if (list[j].year == list[j + 1].year)	
            {
				if (list[j].month > list[j + 1].month)	
				{
					temp = list[j];
					list[j] = list[j + 1];
					list[j + 1] = temp;
				} 
			}
			if ((list[j].year == list[j + 1].year) && (list[j].month == list[j + 1].month))	
            {
				if (list[j].day > list[j + 1].day)	
				{
					temp = list[j];
					list[j] = list[j + 1];
					list[j + 1] = temp;
				} 
			}
			if ((list[j].year == list[j + 1].year) && (list[j].month == list[j + 1].month) && (list[j].day == list[j + 1].day))	
            {
				if (list[j].ID > list[j + 1].ID)
				{
					temp = list[j];
					list[j] = list[j + 1];
					list[j + 1] = temp;
				} 
			}
			
			
        }
    }
}