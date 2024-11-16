#include <iostream>
#include "Func.h"

int main() {
    FuncA func;
    double result = func.compute(1.0, 5);  // приклад виклику функції
    std::cout << "Результат: " << result << std::endl;
    return 0;
}
