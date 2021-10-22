#include "types.h"
#include "stat.h"
#include "user.h"

int main(void)
{
    int count = getReadCount();
    printf(1,"There have been %d times from calling read system call\n",count);
    exit();
}