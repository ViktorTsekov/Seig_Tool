function A = rump()
% Construct the Rump matrix

f = 0.01;

A = [0 1-f 0; -1+f 0 i; 0 -i 0];