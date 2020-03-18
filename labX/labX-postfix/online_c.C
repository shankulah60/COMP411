#include <stdio.h>

//https://www.youtube.com/watch?v=L9xpyah1taw

char buffer[256];

int stack[256];
int stackSize = 0;
void addStack(void){
	int result = stack[stackSize-2] + stack[stackSize-1];
	stack[stackSize-2] = result;
	stackSize--;
}
void multStack(void){
	int result = stack[stackSize-2] * stack[stackSize-1];
	stack[stackSize-2] = result;
	stackSize--;
}
void divStack(void){
	int result = stack[stackSize-2] / stack[stackSize-1];
	stack[stackSize-2] = result;
	stackSize--;
}
void subStack(void){
	int result = stack[stackSize-2] - stack[stackSize-1];
	stack[stackSize-2] = result;
	stackSize--;
}

//int main(int argc, char **argv){
int main(){
	printf("Enter a postfix expression: ");
	fgets(buffer, 255, stdin);
	int val = 0;

	int i = 0;
	int multiplier = 1;
	while (buffer[i] != '\0' && buffer[i] != '\n'){
		char c = buffer[i];
		char d = buffer[i+1];
		i++;
		if(c == ' '){
			continue;
		}
		if (c == '+'){
			addStack();
			continue;
		}if (c == '*'){
			multStack();
			continue;
		}if (c == '/'){
			divStack();
			continue;
		}if (c == '-' && (d <= '0' || d >= '9')){
			subStack();
			continue;
		}
		val = 0;
		multiplier = 1;
		while (c != ' ' && c != '\0' && c != '\n'){
			if (c == '-')
			{
				multiplier = -1;
			}
			if (c >= '0' && c <= '9')
			{
				val = (val*10) + (c-'0');
			}
			c = buffer[i];
			i++;
		}
		val = val * multiplier;
		stack[stackSize] = val;
		stackSize++;
	}
	printf("result = %d\n", stack[stackSize-1]);
	return 0;	
}