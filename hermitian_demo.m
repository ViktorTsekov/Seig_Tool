function A = hermitian_demo(N)

%   A = HERMITIAN_DEMO returns matrix A of dimension 5. It is used as a 
%   numerical examplefor computing Hermitian pseudospectrum.
%
%   Copyright 2009 by D. Kressner and E. Kokiopoulou

A = full(spdiags([0 1 2]',0,3,3));
B = [3 -1; 1 3];
A = [A zeros(3,2); zeros(2,3) B];
