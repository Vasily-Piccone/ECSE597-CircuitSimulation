function Xdc = dcsolvealpha(Xguess, alpha, maxerr)
% Compute dc solution using newtwon iteration for the augmented system
% G*X + f(X) = alpha*b
% Inputs: 
% Xguess is the initial guess for Newton Iteration
% alpha is a paramter (see definition in augmented system above)
% maxerr defined the stopping criterion from newton iteration: Stop the
% iteration when norm(deltaX)<maxerr
% Oupputs:
% Xdc is a vector containing the solution of the augmented system

global G C b DIODE_LIST npnBJT_List

% initialize all variables
dX = zeros(1, size(G, 1));
val = 1;

% initialize Xdc
Xdc = Xguess
i = 0;
conv = false;
while ~conv
   % defining the matrices used in this computation
   psi = G*Xdc + f_vector(Xdc) - alpha.*b;
   d_psi = G + nlJacobian(Xdc);
   fawk = nlJacobian(Xdc)
   
%    dim_psi = size(psi)
%    dim_dpsi = size(d_psi)

   % Calculating the updated values
   dX = -d_psi\psi
   Xdc = dX + Xdc;
%    val = norm(dX, 2);
   
   if norm(dX, 2) < maxerr
       conv = true;
   end
   i=i+1
end




