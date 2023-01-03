#include "pilib.h"


#include <math.h> 
/* program */ 

int j = 3  , i , w = 10 , k , y = 45 ;

double t;
const double N1 = -100  , N2 = 0 , N3 = 10 , N4 = 100 ;
const char* s1 = "Give a real number" ;


int main () {
double i , j ;
 writeString("Give a real number:" );


i = readReal();

writeString(s1);

j = readReal();

if (i < N1 && j < N1)  
	 {

	writeString("Numbers " );
 

	writeReal(i);

	writeString(", " );

	writeReal(j);

	writeString(" are smaller  than " );

	writeReal(N1);

	writeString("\n" );

} 

  
 
 else if (i < N2 && j < N2)  
	 {

	writeString("Numbers " );
 

	writeReal(i);

	writeString(", " );

	writeReal(j);

	writeString(" are smaller  than " );

	writeReal(N2);

	writeString("\n" );

} 

  
 
 else if (i < N3 && j < N3)  
	 {

	writeString("Numbers " );
 

	writeReal(i);

	writeString(", " );

	writeReal(j);

	writeString(" are smaller  than " );

	writeReal(N3);

	writeString("\n" );

} 

  
 
 else if (i < N4 && j < N4)  
	 {

	writeString("Numbers " );
 

	writeReal(i);

	writeString(", " );

	writeReal(j);

	writeString(" are smaller  than " );

	writeReal(N4);

	writeString("\n" );

} 

  
 
 else {

	writeString("Numbers " );
 

	writeReal(i);

	writeString(", " );

	writeReal(j);

	writeString(" are not both smaller  than " );

	writeReal(N4);

	writeString("\n" );

} 

  

   

   

   

  
 
}
// Your program is syntactically correct!
