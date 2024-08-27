#include "Calculator.h"

Calculator::Calculator() {
    // Конструктор по умолчанию
}

Calculator::~Calculator() {
    // Пустой деструктор
}

void Calculator::inputLargeNumbers(mpz_t& num1, mpz_t& num2) {
    std::string num1Str, num2Str;
    
    std::cout << "Введите первое большое число: ";
    std::cin >> num1Str;
    std::cout << "Введите второе большое число: ";
    std::cin >> num2Str;

    mpz_init_set_str(num1, num1Str.c_str(), 10);
    mpz_init_set_str(num2, num2Str.c_str(), 10);
}

void Calculator::calculateLargeNumbers() {
    mpz_t num1, num2, result;
    inputLargeNumbers(num1, num2);

    mpz_init(result);
    mpz_add(result, num1, num2);

    std::cout << "Результат: ";
    mpz_out_str(stdout, 10, result);
    std::cout << std::endl;

    mpz_clear(num1);
    mpz_clear(num2);
    mpz_clear(result);
}

void Calculator::inputMatrices(Matrix2d& mat1, Matrix2d& mat2) {
    std::cout << "Введите элементы первой матрицы 2x2 (построчно): ";
    std::cin >> mat1(0, 0) >> mat1(0, 1) >> mat1(1, 0) >> mat1(1, 1);
    
    std::cout << "Введите элементы второй матрицы 2x2 (построчно): ";
    std::cin >> mat2(0, 0) >> mat2(0, 1) >> mat2(1, 0) >> mat2(1, 1);
}

void Calculator::calculateMatrices() {
    Matrix2d mat1, mat2, result;
    inputMatrices(mat1, mat2);

    result = mat1 + mat2;

    std::cout << "Результирующая матрица:\n";
    std::cout << result << std::endl;
}
