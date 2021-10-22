#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
    int counter = getProcCount();
    printf(1,"There are %d proccesses\n",counter);
    exit();
}