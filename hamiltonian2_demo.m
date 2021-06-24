function A = hamiltonian2_demo(N)

%   A = HAMILTONIAN2_DEMO returns a matrix A of dimension 6. It is used as a
%   numerical example for computing Hamiltonian pseudospectrum.
%
%   Copyright 2009 by D. Kressner and E. Kokiopoulou


B1 = diag([0,-1,1]);
B2 = diag([0,1,-1]);
A = [zeros(3,3) B1; B2 zeros(3,3)];
