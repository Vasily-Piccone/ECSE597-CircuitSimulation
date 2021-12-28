function J = nlJacobian(X)
    % Compute the jacobian of the nonlinear vector of the MNA equations as a 
    % function of X
    % input: X is the current value of the unknown vector.
    % output: J is the jacobian of the nonlinear vector f(X) in the MNA
    % equations. The size of J should be the same as the size of G.
    
    % Diode curve: I = Is(exp(V/VT) - 1)
    global G C DIODE_LIST
    
    % Create the Jacobian matrix F of f(x).
    F = zeros(size(G, 1), size(G, 2));
    
    for i = 1:size(DIODE_LIST, 2)
        diode = DIODE_LIST(i);
    
        n1 = diode.node1;
        n2 = diode.node2;
        v1 = X(diode.node1);
        v2 = X(diode.node2);
      
        dF = (diode.Is / diode.Vt) * exp((v1 - v2) / diode.Vt);
        
        if diode.node1 ~= 0
            F(n1, n1) = F(n1, n1) + dF;
        end
        
        if diode.node2 ~= 0
            F(n2, n2) = F(n2, n2) + dF;
        end
        
        if diode.node1 ~= 0 && diode.node2 ~= 0
            F(n1, n2) = F(n1, n2) - dF;
            F(n2, n1) = F(n2, n1) - dF;
        end
    end
    
    J = F; % G + was removed
end