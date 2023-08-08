function M=Truss_2D(dof,A,E,L,n_1st,n_2st,angle)
K=zeros(dof);
u=[1 0 ; 0 0];
kk=E*A/L*[u -u ; -u u];
C=cos(pi*angle/180);
S=sin(pi*angle/180);
lamda=[C S ; -S C];
O=zeros(2);
T=[lamda O ; O lamda];
k=T'*kk*T;
a=0;
b=0;
for ii=[n_1st*2-1 n_1st*2 n_2st*2-1 n_2st*2 ]
    a=a+1;
    for jj=[n_1st*2-1 n_1st*2 n_2st*2-1 n_2st*2 ]
        b=b+1;
        K(ii,jj)=k(a,b);
    end
    b=0;
end
M.K=K;  % return serial global stiffness matrix
M.k=k;  % return global stiffness matrix
M.kk=kk;    % return local stiffness matrix
M.T=T;  % return Transformation matrix
M.Y=E/L*[-C -S C S];   %return a matrix for caculating stress