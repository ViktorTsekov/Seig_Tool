function A = rump_demo(N)

%   A = RUMP_DEMO(N) returns matrix D of dimension N.
%
%   A is the Rump matrix.
%
%   [1] S.~M. Rump, ``Eigenvalues, pseudospectrum and
%  structured perturbations", Linear Algebra Appl., vol. 413
%  nr. 2-3, 2006, pp. 567--593.

% Copyright 2009 by D. Kressner and E. Kokiopoulou

f = 0.01;
A = [0 1-f 0; -1+f 0 i; 0 -i 0];