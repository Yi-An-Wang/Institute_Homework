function M=Truss_2D(dof,A,E,L,n_1st,n_2st,angle) 
%輸入Truss元素的截面積、桿長、節點編號等資料，此函數可以回傳各類此元素的矩陣
K=zeros(dof);
u=[1 0 ; 0 0]; 
kk=E*A/L*[u -u ; -u u]; % kk:local stiffness matrix
C=cos(pi*angle/180);
S=sin(pi*angle/180);
lamda=[C S ; -S C]; 
O=zeros(2);
T=[lamda O ; O lamda]; % T:transformation matrix
k=T'*kk*T; % k:global stiffness matrix
a=0;
b=0;
for ii=[n_1st*2-1 n_1st*2 n_2st*2-1 n_2st*2 ] 
% 將global stiffness matrix的各項數值依節點編號安排到K矩陣的指定位置
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