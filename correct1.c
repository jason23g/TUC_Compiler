#include "pilib.h"


#include <math.h> 
/* program */ 

int j = 3  , i , w = 10 ;

const int length = 6 ;


int find_max (int *x , int limit)  {
 int i , temp ;
 temp = x [0];


for (i = 0 ; i < limit ; i = i + 1) {

	if (x [i] > temp)  
	 temp = x [i];
  

 

} 

  

return temp; 
 
  
} 

int find_min (int *x , int limit)  {
 int i , temp ;
 temp = x [0];


for (i = 0 ; i < limit ; i = i + 1) {

	if (x [i] < temp)  
	 {

	temp = x [i];
 

} 

  

 

} 

  

return temp; 
 
  
}

void display (int max , int min , char* s1)  {
 const char* newLine = "\n" ;
 writeString("The max value of the array is :" );


writeInt(max);

writeString(newLine);

writeString(s1);

writeInt(min);

writeString(newLine);
 
  
}

void displayIntArray (int *number , int length)  {
 int i = 0 ;
 writeString("The numbers of the array is " );


while(i < length) {

	writeInt(number [i]);
 

	writeString(" " );

	i = i + 1;

} 

  

writeString("\n" );
 
  
}

int* createIntArray (int *number)  {
 number [0] = 1 + (-13);


number [1] = (3 * 5 + 1) % 5;

number [2] = 105 / 5;

number [3] = -1 - 105;

number [4] = pow(-2,7);

number [5] = pow((3 + 2),6);

return number; 
 
  
}

 int main () {
int min , max ;

char* s1 = "The min value of the array is :" ;
int number [5];
int *array_number; array_number = createIntArray(number);


displayIntArray(number,length);

max = find_max(array_number,6);

min = find_min(array_number,6);

display(max,min,s1);
 
 
}
// Your program is syntactically correct!
