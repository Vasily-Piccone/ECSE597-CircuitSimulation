function J = nlJacobian(X)
% Compute the jacobian of the nonlinear vector of the MNA equations as a 
% function of X
% input: X is the current value of the unknown vector.

% output: J is the jacobian of the nonlinear vector f(X) in the MNA
% equations. The size of J should be the same as the size of G.

global G DIODE_LIST

% diode list will give us all the information, we do not need f
% we also need the voltage values for the jacobian, and these are stored in x
% at X(n1), we have a diode voltage 


% Initialize J
J = zeros(size(G));
for i=1:length(DIODE_LIST)
    n1 = DIODE_LIST(i).node1;
    n2 = DIODE_LIST(i).node2;
    v1 = X(DIODE_LIST(i).node1);
    v2 = X(DIODE_LIST(i).node2);
    v12 = v1-v2;
    Vtherm = DIODE_LIST.Vt;
    der = (DIODE_LIST(i).Is/Vtherm)*exp((v12)/Vtherm);
    if (n1~=0)
      J(n1,n1)=J(n1,n1)+der;
    end

    if (n2~=0)
      J(n2,n2)=J(n2,n2)+der;
    end
     if (n1~=0)&(n2~=0)
        J(n1,n2)=J(n1,n2)-der;
        J(n2,n1)=J(n2,n1)-der;
     end
end

% go through the DIODE_LIST and place a function at each respective entry of
% the Jacobian matrix




