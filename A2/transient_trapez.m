

function [tpoints,r] = transient_trapez(t1,t2,h,out)
% [tpoints,r] = Transient_trapez(t1,t2,h,out)
% Perform Transient Analysis using the Trapezoidal Rule for LINEAR
% circuits.
% assume zero initial condition.
% Inputs:  t1 = starting time point (typically 0)
%          t2 = ending time point
%          h  = step size
%          out = output node
% Outputs  tpoints = are the time points at which the output
%                    was evaluated
%          r       = value of the response at above time points
% plot(tpoints,r) should produce a plot of the transient response


global G C b


% x0 = zeros(size(G,2),1);

tpoints = t1:h:t2;
len_t = length(tpoints);
x = zeros(size(G,1), len_t);

for i=2:len_t
    x(:,i) = (G + 2*C/h)\((2*C/h - G)*x(:,i-1) + BTime((i-1)*h + t1) + BTime(i*h + t1));
end

r = x(out, :) 


