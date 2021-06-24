function [V,T,res,k] = lanczsvdskew(U,R,z,gamma,m,v0,tol)
%
% [V,T,res] = lanczsvdskew(U,R,z,gamma,m,v0,tol)
%
% Compute the largest singular triplets of 
%  
%        | B           gamma * I |
%    C = |                       |,
%        | gamma * I   conj(B)   |
%  
% where B = inv(A-z*I), without explicitly forming B. The matrix C
% shows up in the computation of skew-symmetric pseudospectra.
%
% Input arguments: 
% [U,R] : schur decomposition of A
% z     : complex shift
% gamma : the scalar $\gamma$
% m     : maximum number of Lanczos steps
% v0    : starting vector
% tol   : tolerance of the residual
%
% Output arguments:
% V   : the Lanczos basis
% T   : the tridiagonal matrix
% res : the residual history


% Size of A
n = size(U,1);

% normalize v0
V(:,1) = v0/norm(v0);
v_prev = zeros(2*n,1);
w = zeros(2*n,1);
beta  = 0;
for k=1:m
    % Multiplication by C
    x = U'*V(1:n,k);
    x = (R-z*eye(size(R)))\x;
    x = U*x;
    w(1:n) = x + gamma * V(n+1:2*n,k);
    x = U.'*V(n+1:2*n,k);
    x = conj(R-z*eye(size(R)))\x;
    x = conj(U)*x;
    w(n+1:2*n) = gamma * V(1:n,k) + x;    
    % Take a copy of w
    ww = w;
    % Multiplication by C'    
    x = U'*ww(1:n);
    x = (R'-z'*eye(size(R)))\x;
    x = U*x;
    w(1:n) = x + gamma'*ww(n+1:2*n);
    x = U.'*ww(n+1:2*n);
    x = (R.'-z*eye(size(R)))\x;
    x = conj(U)*x;
    w(n+1:2*n) = x + gamma'*ww(1:n);
    
    
    w = w - beta * v_prev;
    alpha = w'*V(:,k);
    w = w - alpha * V(:,k);

    % Full reorthogonalization
    s = V'*w;
    for l=1:k
       w = w - s(l)*V(:,l);
    end

    T(k,k+1) = norm(w);
    T(k+1,k) = T(k,k+1);
    V(:,k+1) = w / T(k,k+1);

    v_prev = V(:,k);
    beta = T(k+1,k);
    T(k,k) = alpha;
    
    % Check for convergence
    if (k>=2)
        [S,theta] = eig(T(1:k,1:k));
        [list,index] = sort(diag(theta));
        res(k) = abs(beta*S(end,index(end-1)));
        if (res(k) <=tol)
            str = sprintf('Lanczos has converged in %d steps.',k);
            %disp(str)
            break;
        end
    end
end

% T is real symmetric tridiagonal
T = real(T);