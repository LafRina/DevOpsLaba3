#include <iostream>
#include <cmath>
#include <cassert>
#include "Func.h"

void testCompute() {
    FuncA func;

    assert(std::abs(func.compute(0, 5) - 1.0) < 1e-6);

    assert(std::abs(func.compute(M_PI / 3, 10) - 0.5) < 1e-6);

    assert(std::abs(func.compute(M_PI / 2, 10)) < 1e-6);

    assert(std::abs(func.compute(M_PI, 15) + 1.0) < 1e-6);

    double result = func.compute(M_PI / 4, 3);
    std::cout << "Approximation with 3 terms for cos(π/4): " << result << std::endl;

    std::cout << "All tests passed successfully!" << std::endl;
}

int main() {
    testCompute();
    return 0;
}

