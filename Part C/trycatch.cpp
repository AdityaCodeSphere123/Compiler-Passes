#include <iostream>
#include <exception>


int main()
{
    int a =1;
    int b = 0;


    try
    {
        if(b == 0)throw std::invalid_argument("Divide By Zero");
        int c = a/b;
    }
    catch(...)
    {
        std::cout << "Exception" << std::endl;
    }
}

