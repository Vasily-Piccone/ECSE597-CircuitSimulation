function r = fsolve(fpoints ,out)
%  fsolve(fpoints ,out)
%  Obtain frequency domain response
% global variables G C b
% Inputs: fpoints is a vector containing the fequency points at which
%         to compute the response in Hz
%         out is the output node
% Outputs: r is a vector containing the value of
%            of the response at the points fpoint


% define global variables
global G C b

% simple frequency solve, use the slides
for k=1:length(fpoints)
    A = G + (2*pi*1i*fpoints(k))*C
    X = A\b
    r(k) = X(out) 
end 