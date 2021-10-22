#include "types.h"
#include "stat.h"
#include "user.h"

int main(void)
{   int count = getReadCount();
    printf(1, "Number of calling Read SYSCALL from boot time till now are: %d\n", count);
    exit();
}