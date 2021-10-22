#include "types.h"
#include "stat.h"
#include "user.h"

int main(void)
{
    printf(1, "Number of calling Read from boot time till now are: %d", getReadCount());
    exit();
}