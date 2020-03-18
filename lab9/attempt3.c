#include <stdio.h>

void makepatterns(int N, int currentlevel, char pattern[]) {
	if(currentlevel==?)
		printf("%s\n", ?);          // print pattern
	else {
		pattern[?]=?;               // set one character to something
		makepatterns(?, ?, ?);      // recursive call
		pattern[?]=?;               // set it to something else
		makepatterns(?, ?, ?);      // recursive call
	}
}

int main() {
	char pattern[21];               // at most 20 chars plus NULL
	int N;
	scanf("%d", &N);                // read N
	pattern[N]='\0';                // terminate string at position N
	makepatterns(N, 0, pattern);    // generate all patterns
}