function Z = psacore_skew(A,W,R,q,x,y,tol,maxiter)
%   Z = psacore_skew(A,W,R,q,x,y,tol,maxiter)
%
% Compute the SKEW-SYMMETRIC $\mu$ value of $(A - zI)^{-1}$.
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

B = [];

% Total number of matrix-vector multiplications
matvecs = 0;
tolsmall = 1e-5;

lx = length(x);
ly = length(y);
Z = zeros(lx,ly);


for jj = 1:lx
    for kk = 1:ly
        % grid point
        zpt = x(jj)+i*y(kk);

        if n < 10,
           B = inv(A - zpt*eye(n));
        end

        
        % candidate left endpoint
        %leftp = 1e-5;
        leftp = 0;
        [fdleftp,fval,mv] = fderFD(B, W, R, zpt, leftp, q, tolsmall);
        matvecs = matvecs + mv;
        % candidate right endpoint
        rightp = 10;
        % Bs = 0.5*(B+B.');
        % singval = svd(Bs);
        % sigma2 = singval(2);
        % rightp = 4*max(svd(B))^2/sigma2;
        [fdrightp,fval,mv] = fderFD(B, W, R, zpt, rightp, q, tolsmall);
        matvecs = matvecs + mv;
        % Find the appropriate interval
        %         while fdleftp >= 0
        %             leftp = leftp/2;
        %             [fdleftp,fval,mv] = fderFD(B, W, R, zpt, leftp, q, tolsmall);
        %             matvecs = matvecs + mv;
        %         end
        while fdrightp <= 0
            rightp = rightp*2;
            [fdrightp,fval,mv] = fderFD(B, W, R, zpt, rightp, q, tolsmall);
            matvecs = matvecs + mv;
        end
        str = sprintf('[%.15f,%.15f]',leftp,rightp);
        %disp(str)
        
        iter = 1;
        while (iter <=maxiter)
            midp = 0.5*(leftp+rightp);
            [fd,fval,mv] = fderFD(B, W, R, zpt, midp, q, tolsmall);
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
        [fd,Z(jj,kk),mv] = fder(B, W, R, zpt, gammaopt, q, tol);
        matvecs = matvecs + mv;
        
    end % end of loop over the y-values
end % end of loop over the x-values
Z = 1./sqrt(abs(Z));


%=========================================================================
function [fd,fval,mv] = fder(B, W, R, z, gamma, q, tol)
% Compute the derivative of sigma2()


if ~isempty(B)
    % Do explicit singular value computation
    [m,n] = size(B);
    mv = 0;
    C = [B (gamma)*eye(m,n); (gamma)*eye(m,n) conj(B)];
    [U,S,V] = svd(C);
    u2 = U(:,2);
    v2 = V(:,2);
    sigma2dot = real(u2'*[zeros(m) eye(m); eye(m) zeros(m)]*v2);
    fd = 2*S(2,2)*sigma2dot - 2*gamma;
    fval = S(2,2)^2 - gamma^2;    
else  
    % Use Lanczos
    [m,n] = size(R);

    % Total number of matvecs
    mv = 0;
    
    % Avoiding explicit inversion of B
    [VV,T,res,mv] = lanczsvdskew(W, R, z, gamma, 2*m, q, tol);
    % Approximate the second singular value
    [Q,Theta] = eig(T);
    Theta = real(sqrt(real(diag(Theta))));
    % sort the singular values
    [list,index] = sort(Theta);
    sigma2 = Theta(index(end-1));
    Q = Q(:,index);
    
    % Approximate the corresponding right singular vector
    Y = VV*Q;
    v2 = Y(:,end-1);
    % Approximate the corresponding left singular vector
    u2 = zeros(2*m,1);
    x = W'*v2(1:n);
    x = (R-z*eye(size(R)))\x;
    x = W*x;
    u2(1:n) = x + gamma * v2(n+1:2*n);
    x = W.'*v2(n+1:2*n);
    x = conj(R-z*eye(size(R)))\x;
    x = conj(W)*x;
    u2(n+1:2*n) = gamma * v2(1:n) + x;
    u2 = u2/sigma2;
    
    % Approximation to the derivative of sigma2
    sigmader = real(u2'*[zeros(m) eye(m); eye(m) zeros(m)]*v2);
    fd = 2*sigma2*sigmader - 2*gamma;
    fval = sigma2^2 - gamma^2;
end



%=========================================================================
function [fd,fval,mv] = fderFD(B, W, R, z, gamma, q, tol)
% Compute the derivative of sigma2() using Finite Differences

if ~isempty(B)
    % Do explicit singular value computation
    [m,n] = size(B);
    mv = 0;
    C = [B (gamma)*eye(m,n); (gamma)*eye(m,n) conj(B)];
    [U,S,V] = svd(C);
    u2 = U(:,2);
    v2 = V(:,2);
    sigma2dot = real(u2'*[zeros(m) eye(m); eye(m) zeros(m)]*v2);
    fd = 2*S(2,2)*sigma2dot - 2*gamma;
    fval = S(2,2)^2 - gamma^2;
else
    [m,n] = size(R);    
    % Discretization step
    dh = 1e-8;
    % Total number of matvecs
    mv = 0;
    
    % Approximate sigma at gamma
    [VV,T,res,mv0] = lanczsvdskew(W, R, z, gamma, 2*m, q, tol);
    mv = mv + mv0;
    % Approximate the second singular value
    Theta = eig(T);
    Theta = real(sqrt(real(Theta)));
    % sort the singular values
    [list,index] = sort(Theta);
    sigma2 = Theta(index(end-1));
    
    
    % Approximate sigma at gamma + dh
    [VV,T,res,mvplus] = lanczsvdskew(W, R, z, gamma+dh, 2*m, q, tol);
    mv = mv + mvplus;
    % Approximate the second singular value
    Theta = eig(T);
    Theta = real(sqrt(real(Theta)));
    % sort the singular values
    [list,index] = sort(Theta);
    fplus = Theta(index(end-1));
    
    % Approximate sigma at gamma - dh
    [VV,T,res,mvminus] = lanczsvdskew(W, R, z, gamma-dh, 2*m, q, tol);
    mv = mv + mvminus;
    % Approximate the second singular value
    Theta = eig(T);
    Theta = real(sqrt(real(Theta)));
    % sort the singular values
    [list,index] = sort(Theta);
    fminus = Theta(index(end-1));
    
    
    % Approximation to the derivative of sigma2
    sigmader = (fplus-fminus)/(2*dh);
    fd = 2*sigma2*sigmader - 2*gamma;
    fval = sigma2^2 - gamma^2;
end
