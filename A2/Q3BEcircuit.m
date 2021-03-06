% Chebychev filter

% define global variables
global G C
global b;
global DIODE_LIST
global TD_SOURCE_LIST_SINE TD_SOURCE_LIST_PWL



% Initialize MNA matrices
DIODE_LIST = struct('node1', [ ], 'node2', [ ], 'Is', [ ], 'Vt', [ ]);
TD_SOURCE_LIST_SINE = struct('SourceName',{ }, 'index1', [ ], 'index2', [ ], 'A', [ ], 'Phi', [ ], 'f', [ ]);
TD_SOURCE_LIST_PWL = struct('SourceName',{ }, 'index1', [ ], 'index2', [ ], 'T', [ ], 'D', [ ]);
N = 4;
G = sparse(N,N)              
C = sparse(N,N)
b = sparse(N,1);  

cursine(1,0,1,1e6,0) % changed from 1e9
res(1,0,1e3)
cap(1,0,0.1e-6) % all capacitor values are originally 1e-9
res(1,2,1e3)
cap(2,0,0.1e-6)
res(2,3,1e3)
cap(3,0,0.1e-6)
res(3,4,1e3)
cap(4,0,0.1e-6)

