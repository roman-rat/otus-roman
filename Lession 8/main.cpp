#include "Calculator.h"

int main() {
    Calculator calculator;
    int choice;

    do {
        std::cout << "Выберите операцию:\n";
        std::cout << "1. Арифметика больших чисел (GMP)\n";
        std::cout << "2. Арифметика матриц (Eigen)\n";
        std::cout << "0. Выход\n";
        std::cout << "Введите выбор: ";
        std::cin >> choice;

        switch (choice) {
            case 1:
                calculator.calculateLargeNumbers();
                break;
            case 2:
                calculator.calculateMatrices();
                break;
            case 0:
                std::cout << "Выход...\n";
                break;
            default:
                std::cout << "Неверный выбор. Пожалуйста, попробуйте снова.\n";
                break;
        }
    } while (choice != 0);

    return 0;
}
