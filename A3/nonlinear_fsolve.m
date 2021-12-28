function r = nonlinear_fsolve(Xdc, fpoints ,out)
%  nonlinear_fsolve(fpoints ,out)
%  Obtain frequency domain response
% global variables G C b bac
% Inputs: fpoints is a vector containing the fequency points at which
%         to compute the response in Hz
%         out is the output node
% Outputs: r is a vector containing the value of
%            of the response at the points fpoint

global  G C b bac 

% f solve by linearizing the non-linear components 
% lecture recording -> AC steady state, 

% voltage gain = v_out/v_in
num_pts = length(fpoints);
J = nlJacobian(Xdc);

X_ac = zeros(length(bac), num_pts); 
p = bac;
for i=1:num_pts
    % we want to solve G+J +jw*C 
    A = J + G + j*2*pi*fpoints(i)*C;
    X_ac(:, i) = A\bac;
end

r = X_ac(out, :);
gain_denom = X_ac(1, :);

gain = r./gain_denom;
figure(1)
hold off
clf
plot(fpoints, gain)
grid
xlabel('Frequency (Hz)')
ylabel('Gain (V/V)')
title('Question 4: Non-linear Fsolve')

