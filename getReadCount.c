#include <typs.h>
#include <user.h>
#include <stat.h>

int main(void){
    printf("Number of calling Read from boot time till now are: %d", getReadCount());
    return 0;
}