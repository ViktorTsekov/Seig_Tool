function Z = psacore_real(A,W,R,q,x,y,tol,maxiter)
%   Z = psacore_real(A,W,R,q,x,y,tol,maxiter)
%
% Compute the REAL $\mu$ value of $(A - zI)^{-1}$
% Implements the Bisection method. It uses the Lanczos method (with full
% reorthogonalization) for svd calculations.
%
% A       : Original matrix A.
% [W,R]   : Schur decomposition of A (W: unitary matrix, R: upper
%           triangular)
% q       : starting vector to be used in the Lanczos method
% x       : x-values of the grid
% y       : y-values of the grid
% tol     : tolerance to use in bisection (i.e., length of the interval).
%           It is typically very small (e.g., 1e-15)
% maxiter : maximum number of iterations in bisection

[m,n] = size(R);
rB = [];
iB = [];

matvecs = 0;
% Relaxed tolerance, used in the iterations of bisection.
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
    	   rB = real(B);
    	   iB = imag(B);
    	end
        
        errflag = 0;        
        
        % Left endpoint
        leftp(1) = 1e-16;
        % Compute the derivative
        try
            [fleft(1),fval,mv] = fder(rB,iB,W,R,zpt,leftp(1),q,tol);
            matvecs = matvecs + mv;
        catch 
            Z(jj,kk) = Inf;
            errflag = 1;
        end
        % Right endpoint
        rightp(1) = 0.99999999999;
        % Compute the derivative
        try 
            [fright(1),fval,mv] = fder(rB,iB,W,R,zpt,rightp(1),q,tol);
            matvecs = matvecs + mv;
        catch
            Z(jj,kk) = Inf;
            errflag = 1;            
        end
        
        gamma = zeros(maxiter,1);        
        ii = 1;
        while (1 & (errflag == 0))
            %----------------
            % Bisection
            %----------------
            % Compute the midpoint
            midp(ii) = 0.5*(leftp(ii) + rightp(ii));
            [fmid(ii),fval,mv] = fder(rB,iB,W,R,zpt,midp(ii),q,tolsmall);
            matvecs = matvecs + mv;
            
            %--------------------------------
            % Pick the appropriate interval
            %--------------------------------
            if fleft(ii)*fmid(ii) < 0
                % pick the left sub-interval
                leftp(ii+1) = leftp(ii);
                fleft(ii+1) = fleft(ii);
                rightp(ii+1) = midp(ii);
                fright(ii+1) = fmid(ii);
            elseif fmid(ii)*fright(ii) < 0
                % pick the right sub-interval
                rightp(ii+1) = rightp(ii);
                fright(ii+1) = fright(ii);
                leftp(ii+1) = midp(ii);
                fleft(ii+1) = fmid(ii);
            elseif fmid(ii)==0
                gammaopt = midp(ii);
                %disp(['Number of iterations needed for convergence: ',num2str(ii)]);
                break;
            else
                disp('??? Solution does not belong to any interval...');
                zpt
                Z(jj,kk) = Inf;
                errflag = 1;
                break;
            end
            str = sprintf('[%.15f,%.15f,%.15f]',leftp(ii+1),midp(ii),rightp(ii+1));
            %disp(str)
            
            % store the estimated solution so far
            gamma(ii) = midp(ii);
            gammaopt = gamma(ii);
            
            %--------------------
            % stopping criterion
            %--------------------
            if (ii>=maxiter)
                disp('Maximum number of iterations has been reached...')
                disp(['Estimated solution: ',num2str(gammaopt)]);
                break;
            elseif (abs(rightp(ii)-leftp(ii))<=tol)
                %disp(['Number of iterations needed for convergence: ',num2str(ii)]);
                %disp(['Optimum solution found: ',num2str(gammaopt)]);
                break;
            end
            
            %------------------------------
            % Increase the iteration count
            %------------------------------
            ii = ii + 1;
        end
        
        if (errflag == 0)
            [gval,Z(jj,kk),mv] = fder(rB,iB,W,R,zpt,gammaopt,q,tol);
            matvecs = matvecs + mv;
        end
    end % end of loop over the y-values
end % end of loop over the x-values
Z = 1./Z;


function [fd,fval,mv] = fder(rB,iB,W,R,z,gamma,q,tol)
% Compute the derivative of the 2nd singular value using the Lanczos
% algorithm

[m,n] = size(R);

if gamma == 0
    error('??? gamma should be strictly larger than 0');
end

if ~isempty(rB),
   % Do explicit singular value computation
   mv = 0;
   C = [rB -1/gamma*iB; gamma*iB rB];
   [U,singval,V] = svd(C);
   Cdot = [zeros(m,m) (1/gamma^2)*iB; iB zeros(m,m)];
   fd = real(U(:,2)'*Cdot*V(:,2));
   fval = singval(2,2);

else
   % Avoiding explicit inversion of B
   [VV,T,res,mv] = lanczsvdreal(W,R,z,gamma,2*m,q,tol);

   % Approximate left and right singular vectors
   [Q,Theta] = eig(T);

   sigma2 = sqrt(Theta(end-1,end-1));
   Y = VV*Q;
   v2 = Y(:,end-1);
   x = W'*(v2(1:m) + i*(1/gamma)*v2(m+1:2*m));
   x = (R-z*eye(size(R)))\x;
   x = W*x;
   u2(1:n) = real(x);
   u2(n+1:2*n) = gamma * imag(x);
   u2 = u2';
   u2 = u2/sigma2;

   %Cdot*V(:,2): 1st part
   t = W'*(zeros(n,1) -i*(1/gamma^2)*v2(n+1:end) );
   t = (R-z*eye(size(R)))\t;
   t = W*t;
   t1 = real(t);
   %Cdot*V(:,2): 2nd part
   t = W'*(zeros(n,1) -i*v2(1:n) );
   t = (R-z*eye(size(R)))\t;
   t = W*t;
   t2 = real(t);
   
   % Approximation to the derivative of sigma2
   fd = real(u2'*[t1;t2]);
   fval = sigma2;
end
