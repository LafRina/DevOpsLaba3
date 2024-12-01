#include <iostream>
#include <chrono>
#include <vector>
#include <algorithm>
#include <cmath>
#include "Func.h"

void TestComputationTime() {
    std::vector<double> values;
    FuncA func;

    auto start = std::chrono::high_resolution_clock::now();

    // Обчислення значень
    for (double i = 1.0; i < 5000.0; i += 0.1) {
        func.compute(i, 100);
    }

    // Сортування значень
    for (int i = 0; i < 500; ++i) {
        std::sort(values.begin(), values.end());
        std::reverse(values.begin(), values.end());
    }

    auto end = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(end - start).count();

    // Виведення часу виконання
    std::cout << "Computation time: " << duration << " ms" << std::endl;

    // Перевірка, чи час обчислень знаходиться в межах від 5 до 20 секунд (5000-20000 мс)
    if (duration >= 5000 && duration <= 20000) {
        std::cout << "Test Passed!" << std::endl;
    } else {
        std::cout << "Test Failed!" << std::endl;
    }
}

int main() {
    TestComputationTime();
    return 0;
}

