Name:           calculator
Version:        1.0
Release:        1%{?dist}
Summary:        CLI калькулятор больших чисел и матриц

License:        GPL
Source0:        %{name}-%{version}.tar.gz

BuildRequires:  gcc-c++, cmake, gmp-devel, eigen3-devel
Requires:       gmp, eigen3

%global debug_package %{nil}

%description
Console калькулятор с использованием GMP и библиотекой Eigen.

%prep
%setup -q

%build
cmake .
make

%install
install -D -m 0755 calculator %{buildroot}%{_bindir}/calculator

%files
%{_bindir}/calculator

%changelog
* Tue Aug 27 2024 rat-romash - 1.0-1
- Первый выпуск калькулятора
