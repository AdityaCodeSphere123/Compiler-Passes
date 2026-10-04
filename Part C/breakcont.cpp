#include <iostream>
#include <vector>
#include <algorithm>

int main()
{
    int i = 0;
    int n = 5;

    while(true)
    {
        if(i < n)break;

        i *= 2;
        i -= 1;

        if(i == 2)continue;
    }
}
