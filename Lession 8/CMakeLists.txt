   cmake_minimum_required(VERSION 3.5)



   project(Calculator)



   set(CMAKE_CXX_STANDARD 11)



   # Указание путей к библиотекам GMP и Eigen вручную

   find_package(Eigen3 REQUIRED)



   # Поиск библиотеки и заголовочных файлов GMP вручную

   find_library(GMP_LIB gmp)

   find_path(GMP_INCLUDE_DIR gmp.h)



   if (GMP_LIB AND GMP_INCLUDE_DIR)

       include_directories(${GMP_INCLUDE_DIR})

       add_executable(calculator main.cpp Calculator.cpp)

       target_link_libraries(calculator ${GMP_LIB} Eigen3::Eigen)

   else()

       message(FATAL_ERROR "Could not find GMP library or include path")

   endif()

   

