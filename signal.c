#include<stdio.h> 
#include<signal.h> 
  
// Handler for SIGINT, caused by 
// Ctrl-C at keyboard 
void handle_sigint(int sig) 
{ 
    puts("Caught signal"); 
}

int main() 
{
    signal(2, handle_sigint); 
    while (1);
}