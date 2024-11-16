#include "Func.h"
#include <cmath>

double FuncA::compute(double x, int n) {
    double sum = 0;
    // Цикл для обчислення суми перших n елементів
    for (int i = 0; i < n; ++i) {
        sum += pow(-1, i) * pow(x, 2*i) / tgamma(2*i + 1);  // tgamma(2*i + 1) це (2*i)!
    }
    return sum;
}
