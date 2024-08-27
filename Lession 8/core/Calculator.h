#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <iostream>
#include <gmp.h>
#include <Eigen/Dense>

using namespace Eigen;

class Calculator {
public:
    Calculator();
    ~Calculator();

    void calculateLargeNumbers();
    void calculateMatrices();

private:
    void inputLargeNumbers(mpz_t& num1, mpz_t& num2);
    void inputMatrices(Matrix2d& mat1, Matrix2d& mat2);
};

#endif // CALCULATOR_H
