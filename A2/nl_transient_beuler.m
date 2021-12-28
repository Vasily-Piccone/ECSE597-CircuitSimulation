function [tpoints,r] = nl_transient_beuler(t1,t2,h,out)
% [tpoints,r] = beuler(t1,t2,h,out)
% Perform transient analysis for NONLINEAR Circuits using Backward Euler
% Assume zero initial condition.
% Inputs:  t1 = starting time point (typically 0)
%          t2 = ending time point
%          h  = step size
%          out = output node
% Outputs  tpoints = are the time points at which the output
%                    was evaluated
%          r       = value of the response at above time points
% plot(tpoints,r) should produce a plot of the transient response

global G C b

tpoints = t1:h:t2;
len_t =length(tpoints);

maxerr = 10^(-6); % same as in assignment 1

x = zeros(size(G, 1), len_t);
A = (G + C / h);
    for i = 2:size(x, 2)
        b_new =  BTime(i * h) + C / h * x(:,i-1); 
        Xguess = x(:,i-1); % double check this to see if it makes sense.
        
        % NR iteration
        converged = false;
        while ~converged
            a = f_vector(x(:, i-1));
            c = -b_new;
            d = Xguess;
            Phi = A * Xguess + f_vector(x(:, i)) - b_new; % This is now correct (check iPad)
            J = nlJacobian(x(:, i)); % check nlJacobian and how it works -> Jacobian is not good ( removed the -1 from the jacobian term)
            
            Phi_p = A + J;
            dX = -1*Phi_p\Phi;
            x(:, i) = x(:, i) + dX;
            Xguess = Xguess + dX; 
            
            if norm(dX, 2) < maxerr
                converged = true;
            end
            count = i
        end
    end
   r = x(out,:)
end