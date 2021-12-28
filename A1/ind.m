function ind(n1,n2,val)
          % ind(n1,n2,val)
          % Add stamp for inductor to the global circuit representation
          % Inductor connected between n1 and n2
          % The indjuctance is val in Henry
          % global G
          % global C
          % global b
          % Date:

     % define global variables
     global G
     global b
     global C
     
   
     
     % Add 1 to n, to make the matrix slightly bigger
     C(end+1, :) = 0; % Add a new row
     C(:, end+1) = 0; % Add a new column
     
     % Do the same to the G Matrix to ensure it is the correct size
     G(end+1, :) = 0; % Add a new row
     G(:, end+1) = 0; % Add a new column
     
     % B vector adjustment
     b(end+1) = 0;
     n = length(b);
     
     % Terms that are constant independent of ground 
     C(n, n) = -val;
     G(n1, n) = 1;
     G(n, n1) = 1;
     
     % if nodes i and j are not grounded
     if (n2 ~= 0)
         G(n2, n) = -1;
         G(n, n2) = -1;
     end
     
     % if node j is grounded
     if (n2 == 0)
         G(j, n) = -1;
         G(n, j) = -1;
     end
     