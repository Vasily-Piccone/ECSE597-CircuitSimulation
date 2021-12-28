function vcvs(nd1,nd2,ni1,ni2,val)
% vcvs(nd1,nd2,ni1,ni2,val)
% Add stamp for a voltage controlled voltage source
% to the global circuit representation
% val is the gain of the vcvs
% ni1 and ni2 are the controlling voltage nodes
% nd1 and nd2 are the controlled voltage nodes
% The relation of the nodal voltages at nd1, nd2, ni1, ni2 is:
% Vnd1 - Vnd2 = val*(Vni1 - Vni2)


global G
global b
global C

% Add a row and a column of zeros to the new matrix
  G(end+1, :) = 0; % Add a new row
  G(:, end+1) = 0; % Add a new column
  
% Do the same with C, as matrix dimensions must agree
  C(end+1, :) = 0; % Add a new row
  C(:, end+1) = 0; % Add a new column
  
  b(end+1) = 0; % Add a zero to the end of b to make sure the size is proper
     if nd1 ~= 0
        G(nd1, end) = 1;
        G(end, nd1) = 1;
    end
    
    if nd2 ~= 0
        G(nd2, end) =  -1;
        G(end, nd2) = -1;
    end
    
    if ni1 ~= 0
        G(end, ni1) = -val;
    end
    if ni2 ~= 0
        G(end, ni2) = val;
    end
%   n = length(b);
% 
% if (val < 1000)
% % Calculate the size of b, and use that to determine the indicis
%   G(nd1, n) = 1;
%   G(n, nd1) = 1;
%  
%   if nd2 ~= 0
%      G(nd2, n) = -1;
%      G(n, nd2) = -1; 
%      G(n, ni2) = val;
%   end
% 
% % if node j is grounded
%   if (nd2 == 0)
%      G(nd2, n) = -1;
%      G(n, nd2) = -1;
%   end
%      
%   if ni1 ~= 0
%      G(n, ni1) = -val;
%   end
% 
% else
%   G(nd1, n) = 1;
%   G(n, nd1) = 1;
%  
%   if nd2 ~= 0
%      G(nd2, n) = -1;
%      G(n, nd2) = -1; 
%      G(n, ni2) = 1/val;
%   end
%   
%   if ni1 ~= 0
%      G(n, ni1) = -1/val;
%   end
end 
