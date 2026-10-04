#include <iostream>
#include <algorithm>


struct myStruct
{

    int* age;
    int* height;
    myStruct(int a1 , int a2) : age{new int(a1)}, height{new int(a2)} 
    {
    
    }

    ~myStruct()
    {
        delete age;
        delete height;
    }
}
;

int main()
{
    auto x = myStruct(1,2);
}
