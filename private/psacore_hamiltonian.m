function Z = psacore_hamiltonian(A,W,R,q,x,y,tol,maxiter)
%   Z = psacore_hamiltonian(A,W,R,q,x,y,tol,maxiter)
%
% It computes the HAMILTIONIAN $\mu$ value of $(A - zI)^{-1}$.
% It implements the Bisection method and uses the Lanczos method (with full
% reorthogonalization) for svd calculations.
%
% A       : Original matrix A
% [W,R]   : Schur decomposition of A (W: unitary matrix, R: upper
%           triangular)
% q       : starting vector to be used in the Lanczos method
% x       : x-values of the grid
% y       : y-values of the grid
% tol     : tolerance to use in bisection (i.e., length of the interval).
%           It is typically very small (e.g., 1e-15)
% maxiter : maximum number of iterations in bisection


[m,n] = size(R);
matvecs = 0;
tolsmall = 1e-5;

B = [];

lx = length(x);
ly = length(y);
Z = zeros(lx,ly);

for jj = 1:lx
    for kk = 1:ly
        % grid point
        zpt = x(jj)+i*y(kk);
        if n < 10,
            m2 = round(m/2);
            J = [zeros(m2) eye(m2); -eye(m2) zeros(m2)];            
            % Compute the resolvent
            B = inv(A-zpt*eye(m));
            B = J*B;
        end
        
        
        % candidate left endpoint
        leftp = -10;
        [fdleftp,fval,mv] = fderFD(B,W,R,zpt,leftp,q,tolsmall);
        matvecs = matvecs + mv;
        % candidate right endpoint
        rightp = 10;
        [fdrightp,fval,mv] = fderFD(B,W,R,zpt,rightp,q,tolsmall);
        matvecs = matvecs + mv;
        % Find the appropriate interval
        while fdleftp >= 0
            leftp = leftp*2;
            [fdleftp,fval,mv] = fderFD(B,W,R,zpt,leftp,q,tolsmall);
            matvecs = matvecs + mv;
        end
        while fdrightp <= 0
            rightp = rightp*2;
            [fdrightp,fval,mv] = fderFD(B,W,R,zpt,rightp,q,tolsmall);
            matvecs = matvecs + mv;
        end
        str = sprintf('[%.15f,%.15f]',leftp,rightp);
        %disp(str)
        
        iter = 1;
        while (iter <=maxiter)
            midp = 0.5*(leftp+rightp);
            [fd,fval,mv] = fderFD(B,W,R,zpt,midp,q,tolsmall);
            matvecs = matvecs + mv;
            if fd > 0
                rightp = midp;
            elseif fd < 0
                leftp = midp;
            else
                %fd == 0
                break;
            end
            if (abs(rightp-leftp)<=tol)
                break;
            end
            str = sprintf('[%.15f,%.15f]',leftp,rightp);
            %disp(str)
            iter = iter + 1;
        end
        gammaopt = midp;
        str = sprintf('Number of iterations needed for convergence: %d', iter);
        %disp(str)
        
        % Compute the objective function at the optimal point
        [fd,Z(jj,kk),mv] = fder(B,W,R,zpt,gammaopt,q,tol);
        matvecs = matvecs + mv;
        
    end % end of loop over the y-values
end % end of loop over the x-values
Z = 1./sqrt(Z);

%=========================================================================
function [fd,fval,mv] = fder(B,W,R,z,gamma,q,tol)
% Compute the derivative of the largest singular value

if ~isempty(B)
    % Do explicit singular value computation
    [m,n] = size(B);
    mv = 0;
    C = B-(gamma)*i*eye(m,n);
    [U,S,V] = svd(C);
    u1 = U(:,1);
    v1 = V(:,1);
    sigmadot = real(-i*u1'*v1);
    fd = 2*S(1,1)*sigmadot - 2*gamma;
    fval = S(1,1)^2 - gamma^2;
else    
    [m,n] = size(R);
    % Total number of matvecs
    mv = 0;
    
    % Avoiding explicit inversion of B
    [VV,T,res,mv] = lanczsvdhamiltonian(W, R, z, gamma, m, q, tol);
    % Approximate the second singular value
    [Q,Theta] = eig(T);
    Theta = real(sqrt(real(diag(Theta))));
    % sort the singular values
    [list,index] = sort(Theta);
    sigma1 = Theta(index(end));
    Q = Q(:,index);
    
    % Approximate the corresponding right singular vector
    Y = VV*Q;
    v1 = Y(:,end);
    % Approximate the corresponding left singular vector
    x = W'*v1;
    x = (R-z*eye(size(R)))\x;
    x = W*x;
    u1 = x - gamma * i * v1;
    u1 = u1/sigma1;
    
    % Approximation to the derivative of sigma2
    fd = real(-i * u1' * v1);
    fval = sigma1^2 - gamma^2;
end


%=========================================================================
function [fd,fval,mv] = fderFD(B,W,R,z,gamma,q,tol)
% Compute the derivative of the largest singular value with Finite
% Differences.

if ~isempty(B)
    % Do explicit singular value computation
    [m,n] = size(B);
    mv = 0;
    C = B-(gamma)*i*eye(m,n);
    [U,S,V] = svd(C);
    u1 = U(:,1);
    v1 = V(:,1);
    sigmadot = real(-i*u1'*v1);
    fd = 2*S(1,1)*sigmadot - 2*gamma;
    fval = S(1,1)^2 - gamma^2;
else
    [m,n] = size(R);
    % Discretization step
    dh = 1e-8;
    % Total number of matvecs
    mv = 0;
    
    % Approximate sigma at gamma
    [VV,T,res,mv0] = lanczsvdhamiltonian(W, R, z, gamma, m, q, tol);
    mv = mv + mv0;
    % Approximate the second singular value
    Theta = eig(T);
    Theta = real(sqrt(real(Theta)));
    % sort the singular values
    [list,index] = sort(Theta);
    sigma1 = Theta(index(end));
    
    % Approximate sigma at gamma + dh
    [VV,T,res,mvplus] = lanczsvdhamiltonian(W, R, z, gamma+dh, m, q, tol);
    mv = mv + mvplus;
    % Approximate the second singular value
    Theta = eig(T);
    Theta = real(sqrt(real(Theta)));
    % sort the singular values
    [list,index] = sort(Theta);
    fplus = Theta(index(end));
    
    % Approximate sigma at gamma - dh
    [VV,T,res,mvminus] = lanczsvdhamiltonian(W, R, z, gamma-dh, m, q, tol);
    mv = mv + mvminus;
    % Approximate the second singular value
    Theta = eig(T);
    Theta = real(sqrt(real(Theta)));
    % sort the singular values
    [list,index] = sort(Theta);
    fminus = Theta(index(end));
    
    % Approximation to the derivative of sigma1
    sigmader = (fplus-fminus)/(2*dh);
    fd = 2*sigma1*sigmader - 2*gamma;
    fval = sigma1^2 - gamma^2;
end
