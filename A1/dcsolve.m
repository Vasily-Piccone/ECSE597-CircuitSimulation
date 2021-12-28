function [Xdc dX] = dcsolve(Xguess, maxerr)
% Compute dc solution using newtwon iteration
% input: Xguess is the initial guess for the unknown vector. 
%        It should be the correct size of the unknown vector.
%        maxerr is the maximum allowed error. Set your code to exit the
%        newton iteration once the norm of DeltaX is less than maxerr
% Output: Xdc is the correction solution
%         dX is a vector containing the 2 norm of DeltaX used in the 
%         newton Iteration. the size of dX should be the same as the number
%         of Newton-Raphson iterations. See the help on the function 'norm'
%         in matlab.


global G C b DIODE_LIST

deltaX = 0; % Placeholder for deltaX

% Defining the functions which we will later require
x_old = Xguess;
err = norm(x_old);

while err > maxerr
    Phi = G*Xguess + f_vector(x_old) - b;
    Phi_prime = G + nlJacobian(x_old);
    
    % evaluate Phi and Phi_prime at x_old
    deltaX = -(Phi_prime)\Phi;
    x_new = x_old + deltaX;
    x_old = x_new;
    err = norm(x_new);
end
Xdc = x_old;
dX = norm(deltaX,2);


% x_new = x_old + deltaX

% repeat the process if there it does not converge, if it does, exit and
% return X