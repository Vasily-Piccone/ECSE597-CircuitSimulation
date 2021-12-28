function f = f_vector(X)
%% Compute the nonlinear vector of the MNA equations as a function of x
global b DIODE_LIST npnBJT_LIST

N = size(b);
f = zeros(N); % Initialize the f vector (same size as b)

NbDiodes = size(DIODE_LIST,2);
NbBJTs = size(npnBJT_LIST,2);

%% Fill in the Fvector for Diodes
for I = 1:NbDiodes
    if (DIODE_LIST(I).node1 ~= 0) && (DIODE_LIST(I).node2 ~= 0) 
        v1 = X(DIODE_LIST(I).node1); %nodal voltage at anode
        v2 = X(DIODE_LIST(I).node2); %nodal voltage at cathode
        Vt = DIODE_LIST(I).Vt; % Vt of diode (part of diode model)
        Is = DIODE_LIST(I).Is; % Is of Diode (part of diode model)
        diode_current = Is*(exp((v1-v2)/Vt)-1);
        f(DIODE_LIST(I).node1) = f(DIODE_LIST(I).node1) + diode_current;
        f(DIODE_LIST(I).node2) = f(DIODE_LIST(I).node2) - diode_current;
    elseif (DIODE_LIST(I).node1 == 0)
        v2 = X(DIODE_LIST(I).node2); %nodal voltage at cathode
        Vt = DIODE_LIST(I).Vt; % Vt of diode (part of diode model)
        Is = DIODE_LIST(I).Is; % Is of Diode (part of diode model)
        diode_current = Is*(exp((-v2)/Vt)-1);
        f(DIODE_LIST(I).node2) = f(DIODE_LIST(I).node2) - diode_current;
    elseif (DIODE_LIST(I).node2 == 0)
        v1 = X(DIODE_LIST(I).node1); %nodal voltage at anode
        Vt = DIODE_LIST(I).Vt; % Vt of diode (part of diode model)
        Is = DIODE_LIST(I).Is; % Is of Diode (part of diode model)
        diode_current = Is*(exp((v1)/Vt)-1);
        f(DIODE_LIST(I).node1) = f(DIODE_LIST(I).node1) + diode_current;
    end
end

%% Fill in the Fvector for BJTs
for I=1:NbBJTs
     
     %get Nodes Numbers
     cNode = npnBJT_LIST(I).collectorNode;
     bNode = npnBJT_LIST(I).baseNode;
     eNode = npnBJT_LIST(I).emitterNode;    
     
     % get other parameters
     Vt = npnBJT_LIST(I).Vt;
     Is = npnBJT_LIST(I).Is;
     alphaR = npnBJT_LIST(I).alphaR;
     alphaF = npnBJT_LIST(I).alphaF;
     
     if(cNode~=0)&&(bNode~=0)&&(eNode~=0) % all nodes present (DONE)
         % Deleting the zero nodes in the other parts of the problem
         % get nodal voltages
         Vbe = X(bNode)-X(eNode);
         Vbc = X(bNode)-X(cNode);
         % diode currents 
         If = Is*(exp(Vbe/Vt)-1);
         Ir = Is*(exp(Vbc/Vt)-1);
         
      f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
      f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
      f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
     
     elseif (cNode~=0)&&(bNode==0)&&(eNode~=0) % Base is Grounded 
       % get nodal voltages 
       Vbe = -X(eNode);
       Vbc = -X(cNode);
       

       Ir = Is*(exp(Vbc/Vt)-1);
       If = Is*(exp(Vbe/Vt)-1);
     
       % This is fine, as only one node is grounded
      f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
      % f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
      f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
    
     elseif (cNode~=0)&&(bNode~=0)&&(eNode==0) % Emitter is Grounded 
     % get nodal voltages
       Vbe = X(bNode);
       Vbc = X(bNode)-X(cNode);
   

      Ir = Is*(exp(Vbc/Vt)-1);
      If = Is*(exp(Vbe/Vt)-1);
     
      f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
      f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
      % f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
      
    elseif (cNode==0)&&(bNode~=0)&&(eNode~=0) % Collector is Grounded (DONE)
   
    Vbe = X(bNode)-X(eNode);
    Vbc = X(bNode);
    
    Ir = Is*(exp(Vbc/Vt)-1);
    If = Is*(exp(Vbe/Vt)-1);
      
    % f(cNode) =  f(cNode)  -Ir            +    alphaF*If ;
    f(bNode) =  f(bNode)  +Ir*(1-alphaR) +    If*(1-alphaF);
    f(eNode) =  f(eNode)  +Ir*alphaR     -    If;
      
     elseif(cNode~=0)&&(bNode==0)&&(eNode==0) % Base and Emitter are grounded
       % Vbe will be zero, thus If=0 always (did not include Vbe = 0 in
       % code)
       
       % by KCL, nothing changes, therefore leave the vector as is
%         Ir = 0;
%         If = 0; 

     end 
end
