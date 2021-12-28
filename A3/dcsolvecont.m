function Xdc = dcsolvecont(n_steps,maxerr)
% Compute dc solution using newton iteration and continuation method
% (power ramping approach)
% inputs:
% n_steps is the number of continuation steps between zero and one that are
% to be taken. For the purposes of this assigments the steps should be 
% linearly spaced (the matlab function "linspace" may be useful).
% maxerr is the stopping criterion for newton iteration (stop iteration
% when norm(deltaX)<maxerr


global G C b DIODE_LIST


% initialize the b vectors to be used for power ramping
alphas = linspace(0, 1, n_steps);
Xdc = zeros(size(G,1), 1);

for i=1:n_steps
    Xdc = dcsolvealpha(Xdc, alphas(i), maxerr);
end