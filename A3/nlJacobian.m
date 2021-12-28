function J = nlJacobian(X)
% Compute the jacobian of the nonlinear vector of the MNA equations as a 
% function of X
% input: X is the current value of the unknown vector.
% output: J is the jacobian of the nonlinear vector f(X) in the MNA
% equations. The size of J should be the same as the size of G.

global G DIODE_LIST npnBJT_LIST
J = zeros(size(G));

%% Add the Jacobian for diode -- 
%copy paste the one you implemented in your previous assignment 
  % Create the Jacobian matrix F of f(x).
    F = zeros(size(G));
    
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
%% Add the Jacobian for BJT
M = zeros(size(G));

for i = 1:size(npnBJT_LIST, 2)
        bjt = npnBJT_LIST(i);
        
        % Get all bjt values
        node_b = bjt.baseNode;
        node_e = bjt.emitterNode;
        node_c = bjt.collectorNode;
        alpha_f = bjt.alphaF;
        alpha_r = bjt.alphaR;
        Is = bjt.Is;
        Vt = bjt.Vt;
        
%% Calculate Vbe and Vbc
        Vbe = X(node_b) - X(node_e);
        Vbc = X(node_b) - X(node_c);
      
%% add necessary conditions (check which diodes are conducting)
%% Do not need to check the conditions for the Vbe and Vbc
%         % partial derivatives of the F(b) entry
%         dFb_dVb = (1-alpha_f)*(Is/Vt)*exp(Vbe/Vt) + (1-alpha_r)*(Is/Vt)*exp(Vbc/Vt);
%         dFb_dVc = -(1-alpha_r)*(Is/Vt)*exp(Vbc/Vt);
%         dFb_dVe = -(1-alpha_f)*(Is/Vt)*exp(Vbe/Vt);
%         
%         % partial derivatives of the F(c) entry
%         dFc_dVb = -Is/Vt*exp(Vbc/Vt) + alpha_f*Is/Vt*exp(Vbe/Vt);
%         dFc_dVc = Is/Vt*exp(Vbc/Vt);
%         dFc_dVe = -alpha_f*Is/Vt*exp(Vbe/Vt);
%         
%         % partial derivatives of the F(e) entry
%         dFe_dVb = -(Is/Vt)*exp(Vbe/Vt)+alpha_f*(Is/Vt)*exp(Vbc/Vt);
%         dFe_dVc = -alpha_f*(Is/Vt)*exp(Vbc/Vt);
%         dFe_dVe = (Is/Vt)*exp(Vbe/Vt);
        
            
            if(node_c~=0)&&(node_b~=0)&&(node_e~=0) % all nodes present
                
                % taking care of the b node derivatives (double check
                % derivatives) (FIXED)
                M(node_b, node_b) = M(node_b, node_b) + (1-alpha_f)*(Is/Vt)*exp(Vbe/Vt) + (1-alpha_r)*(Is/Vt)*exp(Vbc/Vt); % CORRECT
                M(node_b, node_c) = M(node_b, node_c) - (1-alpha_r)*(Is/Vt)*exp(Vbc/Vt); % CORRECT
                M(node_b, node_e) = M(node_b, node_e) - (1-alpha_f)*(Is/Vt)*exp(Vbe/Vt); % CORRECT
                % changed node_b, node_c and node_b, node_e
                
                % taking care of the c node derivatives (FIXED)
                M(node_c, node_b) = M(node_c, node_b) - Is/Vt*exp(Vbc/Vt) + alpha_f*Is/Vt*exp(Vbe/Vt); %CORRECT
                M(node_c, node_c) = M(node_c, node_c) + Is/Vt*exp(Vbc/Vt); %CORRECT
                M(node_c, node_e) = M(node_c, node_e) - alpha_f*Is/Vt*exp(Vbe/Vt); %ADDED (CORRECT)
                
                % taking care of the e node derivatives (FIXED)
                M(node_e, node_b) = M(node_e, node_b) - (Is/Vt)*exp(Vbe/Vt) + alpha_r*(Is/Vt)*exp(Vbc/Vt); % CORRECT
                M(node_e, node_c) = M(node_e, node_c) - alpha_r*(Is/Vt)*exp(Vbc/Vt); % CORRECT
                M(node_e, node_e) = M(node_e, node_e) + (Is/Vt)*exp(Vbe/Vt); % CORRECT
                
                % focus on this one first, the rest will follow (delete the
                % nodes that do not exist.
                
            elseif (node_c~=0)&&(node_b==0)&&(node_e~=0) % base is grounded, therefore remove those currents
                
                % taking care of the c node derivatives
                M(node_c, node_c) = M(node_c, node_c) + Is/Vt*exp(Vbc/Vt);
                M(node_c, node_e) = M(node_c, node_e) - alpha_f*(Is/Vt)*exp(Vbe/Vt); %ADDED
                
                % taking care of the e node derivatives
                M(node_e, node_c) = M(node_e, node_c) - alpha_r*(Is/Vt)*exp(Vbc/Vt);
                M(node_e, node_e) = M(node_e, node_e) + (Is/Vt)*exp(Vbe/Vt); % ADDED
                
            elseif (node_c~=0)&&(node_b~=0)&&(node_e==0) % Emitter is grounded
               
                % taking care of the b node derivatives
                M(node_b, node_b) = M(node_b, node_b) + (1-alpha_f)*(Is/Vt)*exp(Vbe/Vt); % add the right values!
                M(node_b, node_c) = M(node_b, node_c) -(1-alpha_r)*(Is/Vt)*exp(Vbc/Vt); %ADDED
                
                % taking care of the c node derivatives
                M(node_c, node_b) = M(node_c, node_b) - Is/Vt*exp(Vbc/Vt);
                M(node_c, node_c) = M(node_c, node_c) + Is/Vt*exp(Vbc/Vt);
                
            elseif (node_c==0)&&(node_b~=0)&&(node_e~=0) % Collector is Grounded
                % taking care of the b node derivatives
                M(node_b, node_b) = M(node_b, node_b) + (1-alpha_f)*(Is/Vt)*exp(Vbe/Vt); % add the right values!
                M(node_b, node_e) = M(node_b, node_e) + -(1-alpha_f)*(Is/Vt)*exp(Vbe/Vt);
                
                % taking care of the e node derivatives
                M(node_e, node_b) = M(node_e, node_b) + alpha_f*(Is/Vt)*exp(Vbc/Vt);
                M(node_e, node_e) = M(node_e, node_e) - (Is/Vt)*exp(Vbe/Vt); % ADDED
                
            elseif(node_c~=0)&&(node_b==0)&&(node_e==0) % Base and  Emitter are grounded
               % In this instance, the currents would be zero, and thus the
               % derivatives of the currents would be zero. Thus, do not
               % adjust the values
               
               % We know that this portion is fine, as this is not used by
               % the program.
            end
    end

%% Create Jacobian for BJT
emmm = M
% efff = F 
J = F + M;