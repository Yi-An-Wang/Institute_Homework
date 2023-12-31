function [g,geq]=nonlcon(r)
A=r.^2*pi; % A:截面積
E=200e9; % E:楊氏係數
L=[9.14 9.14*2^(1/2)]; % L:桿長
dof=12; % dof:自由度(degree of freedom)
yst=250e6; % yst:降伏強度
K=zeros(dof); % K是初始化12*12的stiffness matrix(勁度矩陣)
n1=[5 3 6 4 4 2 5 6 3 4]; % 將每根元素的node_j依照順序排列
n2=[3 1 4 2 3 1 4 3 2 1]; % 將每根元素的node_i依照順序排列
angle=[0 0 0 0 90 90 -45 45 -45 45]; % 將每根元素的角度照順序列出
M=cell(5,10); % 創造5*10的cellarray
stname=["K","k","kk","T","Y"]; % 依序將cellarray的每row命名
% "K"列: 儲存每根元素的global stiffness matrix(編號過的)
% "k"列: 儲存每根元素的global stiffness matrix(未編號的)
% "kk"列: 儲存每根元素的local stiffness matrix
% "T"列: 儲存每根元素的Transformation matrix
% "Y"列: 儲存用於計算應力的矩陣(Y=E/L*[-C -S C S])
M=cell2struct(M,stname,1); % 將cellarray轉換成structure並指派給M
for ii=1:10 % 呼叫Truss_2D函數，將元素(ii)的上述5個矩陣指派給M(ii)structure
    if ii<=6
        M(ii)=Truss_2D(dof,A(1),E,L(1),n1(ii),n2(ii),angle(ii));
    else
        M(ii)=Truss_2D(dof,A(2),E,L(2),n1(ii),n2(ii),angle(ii));
    end
end
for ii=1:10
    K=K+M(ii).K; % 執行Direct stiffness method
end
% F=K*U
% F[]=[0 0 0 -F 0 0 0 -F na na na na]' (na:未知)
% U[]=[na na na na na na 0 0 0 0]' (na:未知)
U=zeros(dof,1); % U:初始的位移矩陣
F=zeros(dof,1); % F:初始的力矩陣
F(4)=-1e7; % node2受力10^7 N 向下
F(8)=-1e7; % node4受力10^7 N 向下
kf=[K(1:8,1:8) F(1:8)]; % 結合前8項勁度矩陣和已知的力矩陣成為auhmented matrix
KF=rref(kf); % 形成reduced row echelon form
U(1:8)=KF(:,9); % 得到節點位移量
% F(9:12)=K(9:12,9:12)*U(9:12);
% R=F(9:12); 這兩行是回推reaction force，但是作業不需要所以變成comment
g=zeros(1,13); % 總共有13個非線性拘束條件
for ii=1:10 % 1~10的拘束條件是限制每根元素所承受的應力不能超過降伏應力
    u=[U(n1(ii)*2-1) U(n1(ii)*2) U(n2(ii)*2-1) U(n2(ii)*2)]';
    stress=M(ii).Y*u;
    g(ii)=abs(stress)-yst;
end
g(11)=abs(U(3))-0.02; % 節點2的X軸向位移不能超過0.02m
g(12)=abs(U(4))-0.02; % 節點2的Y軸向位移不能超過0.02m
g(13)=(U(3)^2+U(4)^2)^0.5-0.02; % 節點2的總位移量不能超過0.02m
geq=[];