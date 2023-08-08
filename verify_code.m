r=[0.3 0.2663];
A=r.^2*pi;
E=200e9;
L=[9.14 9.14*2^(1/2)];
dof=12;
yst=250e6;
K=zeros(dof);
n1=[5 3 6 4 4 2 5 6 3 4];
n2=[3 1 4 2 3 1 4 3 2 1];
angle=[0 0 0 0 90 90 -45 45 -45 45];
M=cell(5,10);
stname=["K","k","kk","T","Y"];
M=cell2struct(M,stname,1);
for ii=1:10
    if ii<=6
        M(ii)=Truss_2D(dof,A(1),E,L(1),n1(ii),n2(ii),angle(ii));
    else
        M(ii)=Truss_2D(dof,A(2),E,L(2),n1(ii),n2(ii),angle(ii));
    end
end
for ii=1:10
    K=K+M(ii).K;
end
% F=K*U
% F[]=[0 0 0 -F 0 0 0 -F na na na na]'
% U[]=[na na na na na na 0 0 0 0]'
U=zeros(dof,1);
F=zeros(dof,1);
F(4)=-1e7; % 10^7 N 向下
F(8)=-1e7; % 10^7 N 向下
kf=[K(1:8,1:8) F(1:8)];
KF=rref(kf);
U(1:8)=KF(:,9);
% F(9:12)=K(9:12,9:12)*U(9:12);
% R=F(9:12);
stress=zeros(1,10);
for ii=1:10
    u=[U(n1(ii)*2-1) U(n1(ii)*2) U(n2(ii)*2-1) U(n2(ii)*2)]';
    stress(ii)=M(ii).Y*u;
end